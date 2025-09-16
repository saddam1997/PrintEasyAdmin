// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:printeasy_admin/util/utils.dart';

class ImageService {
  const ImageService._();

  static const ImageService _service = ImageService._();

  static ImageService get i => _service;

  Future<Uint8List?> pickImage() async {
    final completer = Completer<Uint8List?>();

    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files![0];
        final reader = html.FileReader();

        reader.readAsArrayBuffer(file); // Use ArrayBuffer instead of DataURL
        reader.onLoadEnd.listen((e) {
          completer.complete(reader.result as Uint8List);
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  Future<List<Uint8List>> pickMultipleImages() async {
    final completer = Completer<List<Uint8List>>();

    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final images = <Uint8List>[];
        var loadedCount = 0;

        for (final file in files) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoadEnd.listen((e) {
            images.add(reader.result as Uint8List);
            loadedCount++;

            if (loadedCount == files.length) {
              completer.complete(images);
            }
          });
        }
      } else {
        completer.complete([]);
      }
    });

    return completer.future;
  }

  Future<String?> uploadImage({
    required Uint8List file,
    required String fileName,
    String directory = 'uploads',
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('$directory/$fileName');
      final extension = file.fileExtension;
      final metadata = SettableMetadata(
        contentType: 'image/$extension',
        contentDisposition: 'inline',
        customMetadata: {
          'quality': '100',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      final uploadTask = storageRef.putData(file, metadata);

      // Get the download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  /*
  Future<String?> uploadImage({
    required Uint8List file,
    required String fileName,
    String directory = 'uploads',
    int quality = 100,
    int maxWidth = 5000,
    int maxHeight = 5000,
  }) async {
    try {
      // Decode and resize image while maintaining quality
      final codec = await instantiateImageCodec(
        file,
        targetWidth: maxWidth,
        targetHeight: maxHeight,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ImageByteFormat.png);
      final optimizedImageData = data!.buffer.asUint8List();

      final storageRef = FirebaseStorage.instance.ref().child('$directory/$fileName');
      final extension = file.fileExtension;
      final metadata = SettableMetadata(
        contentType: 'image/$extension',
        contentDisposition: 'inline',
        customMetadata: {
          'quality': quality.toString(),
          'width': maxWidth.toString(),
          'height': maxHeight.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      final uploadTask = storageRef.putData(optimizedImageData, metadata);

      // Get the download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
   */

  Future<void> deleteImage(String imageUrl) async {
    final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
    await storageRef.delete();
  }
}

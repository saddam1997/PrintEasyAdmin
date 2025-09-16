// ignore_for_file: avoid_web_libraries_in_flutter,  deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printeasy_utils/printeasy_utils.dart';
import 'package:printing/printing.dart';

class PdfManager {
  PdfManager(this.order);

  final OrderModel order;

  Future<bool> generatePdf(BuildContext context) async {
    try {
      final pdfs = <Future>[];
      final shipmentId = order.shiprocket?.orderNumber ?? order.shipmentId;
      if (shipmentId == null) {
        await Utility.showInfoDialog(DialogModel.error('ShipmentId of order is absent'));
        return false;
      }
      for (var index = 0; index < order.items.length; index++) {
        final item = order.items[index];
        pdfs.add(
          item.bookType != null
              ? _generateBookPdf(
                  context,
                  shipmentId,
                  item,
                )
              : _generateProductPdf(
                  context,
                  shipmentId,
                  item,
                ),
        );
      }

      await Future.wait(pdfs);
      return true;
    } catch (e) {
      await Utility.showInfoDialog(DialogModel.error('Error in generating pdf $e'));
      return false;
    }
  }

  Future<void> _generateBookPdf(BuildContext context, String shipmentId, ItemModel item) async {
    final bleed = _convertToPixels(3);
    final pdf = pw.Document();

    final pdfFormat = item.size == 'A4'
        ? PdfPageFormat.a4
        : item.size == 'A5'
            ? PdfPageFormat.a5
            : PdfPageFormat.letter;

    final data = await Future.wait([
      networkImage(item.imageUrl),
      Utility.captureFromWidget(
        SizedBox(
          height: _convertToPixels(100),
          width: _convertToPixels(250),
          child: CodeManager.generateBarCode(
            shipmentId,
            style: context.headlineLarge,
          ),
        ),
        context: context,
      )
    ]);

    final image = data[0] as pw.ImageProvider;
    final barCodeData = data[1] as Uint8List?;

    pdf.addPage(
      pw.Page(
        pageFormat: pdfFormat,
        margin: pw.EdgeInsets.all(bleed),
        build: (context) => pw.Stack(
          fit: pw.StackFit.expand,
          alignment: pw.Alignment.center,
          children: [
            pw.Positioned.fill(
              child: pw.Image(
                image,
                fit: pw.BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: pdfFormat,
        margin: pw.EdgeInsets.all(bleed),
        build: (context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text('Qty: ${item.quantity}'),
              pw.SizedBox(height: 8),
              pw.Image(
                pw.MemoryImage(barCodeData!),
                width: _convertToPixels(40),
              ),
            ],
          ),
        ),
      ),
    );

    await _download(pdf);
  }

  Future<void> _generateProductPdf(BuildContext context, String shipmentId, ItemModel item) async {
    final bleed = _convertToPixels(3);
    final pdf = pw.Document();

    // const width = 72 * PdfPageFormat.cm;
    // const height = width * 1.414;

    // const pdfFormat = PdfPageFormat(
    //   width,
    //   height,
    //   marginAll: 3 * PdfPageFormat.cm,
    // );
    const pdfFormat = PdfPageFormat.a4;

    // final bytes = await Utility.captureFromWidget(
    //   Column(
    //     children: [
    //       Expanded(
    //         child: Image.network(
    //           item.imageUrl,
    //           fit: BoxFit.contain,
    //         ),
    //       ),
    //       Row(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           if (item.productImageUrl.isNotEmpty) ...[
    //             Image.network(
    //               item.productImageUrl,
    //               fit: BoxFit.contain,
    //               height: _convertToPixels(100),
    //               width: _convertToPixels(100),
    //             ),
    //             SizedBox(
    //               height: _convertToPixels(100),
    //               width: _convertToPixels(100),
    //               child: Stack(
    //                 fit: StackFit.expand,
    //                 alignment: Alignment.center,
    //                 children: [
    //                   Image.network(
    //                     item.productImageUrl,
    //                     fit: BoxFit.contain,
    //                   ),
    //                   Transform.scale(
    //                     scale: 0.6,
    //                     child: Image.network(
    //                       item.imageUrl,
    //                       fit: BoxFit.contain,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text(
    //                 'Name: ${item.label}',
    //                 style: context.bodyMedium?.copyWith(
    //                   fontSize: _convertToPixels(14),
    //                 ),
    //               ),
    //               const SizedBox(height: 8),
    //               Text(
    //                 'SKU: ${item.sku}',
    //                 style: context.bodyMedium?.copyWith(
    //                   fontSize: _convertToPixels(14),
    //                 ),
    //               ),
    //               const SizedBox(height: 8),
    //               Text(
    //                 'Qty: ${item.quantity}',
    //                 style: context.bodyMedium?.copyWith(
    //                   fontSize: _convertToPixels(14),
    //                 ),
    //               ),
    //               const SizedBox(height: 8),
    //             ],
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             spacing: 8,
    //             children: [
    //               for (var option in item.options) ...[
    //                 Text(
    //                   '${option.content}: ${option.options.first.content}',
    //                   style: context.bodyMedium?.copyWith(
    //                     fontSize: _convertToPixels(14),
    //                   ),
    //                 ),
    //               ],
    //             ],
    //           ),
    //           SizedBox(
    //             height: _convertToPixels(100),
    //             width: _convertToPixels(250),
    //             child: CodeManager.generateBarCode(
    //               shipmentId,
    //               style: context.headlineLarge,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   context: context,
    //   pixelRatio: 2.5,
    //   targetSize: const Size(4000, 4000),
    // );

    // if (bytes != null) {
    //   await _downloadImage(bytes);
    // }
    // // await _downloadImageFromUrl(item.imageUrl);

    // return;

    // shipmentId = shipmentId.padLeft(12, '0');

    final data = await Future.wait([
      networkImage(item.imageUrl),
      Utility.captureFromWidget(
        SizedBox(
          height: _convertToPixels(100),
          width: _convertToPixels(250),
          child: CodeManager.generateBarCode(
            shipmentId,
            style: context.headlineLarge,
          ),
        ),
        context: context,
      ),
      if (item.productImageUrl.isNotEmpty) ...[
        networkImage(item.productImageUrl),
      ],
    ]);

    final image = data[0] as pw.ImageProvider;
    final barCodeData = data[1] as Uint8List?;
    final productImage = item.productImageUrl.isNotEmpty ? data[2] as pw.ImageProvider? : null;
    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          buildBackground: (context) => pw.SizedBox.expand(),
          pageFormat: pdfFormat,
          margin: pw.EdgeInsets.all(bleed),
        ),
        build: (context) => pw.Stack(
          fit: pw.StackFit.expand,
          alignment: pw.Alignment.center,
          children: [
            pw.Positioned.fill(
              child: pw.Image(
                image,
                fit: pw.BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );

    if (productImage != null) {
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: pdfFormat,
            margin: pw.EdgeInsets.all(bleed),
          ),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Expanded(
                child: pw.Image(
                  productImage,
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.Divider(),
              pw.Expanded(
                child: pw.Stack(
                  fit: pw.StackFit.expand,
                  alignment: pw.Alignment.center,
                  children: [
                    pw.Center(
                      child: pw.Image(
                        productImage,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                    pw.Center(
                      child: pw.Transform.scale(
                        scale: 0.6,
                        child: pw.Image(
                          image,
                          fit: pw.BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: pdfFormat,
        margin: pw.EdgeInsets.all(bleed),
        build: (context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text('Name: ${item.label}'),
              pw.SizedBox(height: 8),
              pw.Text('SKU: ${item.sku}'),
              pw.SizedBox(height: 8),
              pw.Text('Qty: ${item.quantity}'),
              pw.SizedBox(height: 8),
              for (var option in item.options) ...[
                pw.Text('${option.content}: ${option.options.first.content}'),
                pw.SizedBox(height: 8),
              ],
              pw.Image(
                pw.MemoryImage(barCodeData!),
                width: _convertToPixels(40),
              ),
            ],
          ),
        ),
      ),
    );

    await _download(pdf);
  }

  Future<void> _download(pw.Document pdf) async {
    var pdfBytes = await pdf.save();

    final blob = html.Blob([pdfBytes], 'application/pdf');

    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'pdf_${order.orderId}_${DateTime.now().millisecondsSinceEpoch}.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadImage(Uint8List bytes) async {
    final canvas = html.CanvasElement();
    final ctx = canvas.context2D;

    final img = html.ImageElement();
    img.src = html.Url.createObjectUrl(html.Blob([bytes], 'image/png'));

    // Wait for image to load
    await img.onLoad.first;

    // Set canvas size to match image
    canvas.width = img.width;
    canvas.height = img.height;

    // Draw image to canvas
    ctx.drawImage(img, 0, 0);

    // Convert to blob and download
    final blob = await canvas.toBlob('image/png');
    final url = html.Url.createObjectUrl(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'image_${DateTime.now().millisecondsSinceEpoch}.png')
      ..click();

    // Cleanup
    html.Url.revokeObjectUrl(url);
    html.Url.revokeObjectUrl(img.src!);
  }

  Future<void> _downloadImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final imageBytes = response.bodyBytes;

        // Create a canvas to process the image
        final canvas = html.CanvasElement();
        final ctx = canvas.context2D;

        // Create an image element
        final img = html.ImageElement();
        img.src = html.Url.createObjectUrl(html.Blob([imageBytes], 'image/png'));

        // Wait for image to load
        await img.onLoad.first;

        // Set canvas size to match image
        canvas.width = img.width;
        canvas.height = img.height;

        // Enable high quality settings
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';

        // Draw image with high quality settings
        ctx.drawImage(img, 0, 0);

        // Get the processed image data in WebP format with maximum quality
        final processedImageBytes = await canvas.toBlob('image/webp', 1.0);

        // Download the processed image
        final processedUrl = html.Url.createObjectUrl(processedImageBytes);
        html.AnchorElement(href: processedUrl)
          ..setAttribute('download', 'image_${order.orderId}_${DateTime.now().millisecondsSinceEpoch}.webp')
          ..click();

        // Cleanup
        html.Url.revokeObjectUrl(processedUrl);
        html.Url.revokeObjectUrl(img.src ?? '');
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }

  double _convertToPixels(double mm) {
    const mmToInch = 25.4;
    const pointsPerInch = 72.0;

    var inches = mm / mmToInch;

    var points = inches * pointsPerInch;
    return points;
  }
}

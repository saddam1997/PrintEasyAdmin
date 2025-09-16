import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';

class AppUtility {
  static String apiKey = '';

  static StreamSubscription<User?>? tokenStream;

  static Future<String> get token => DBWrapper.i.getSecuredValue(AppKeys.accessToken);

  static Future<Map<String, String>> get headers => token.then((value) => value.header);

  static void listenTokenChanges() async {
    try {
      cancelTokenListener();
      tokenStream = FirebaseAuth.instance.idTokenChanges().listen((User? user) {
        if (user != null) {
          user.getIdToken().then((token) {
            if (token != null) {
              DBWrapper.i.saveValueSecurely(AppKeys.accessToken, token);
            }
          });
        }
      });
    } catch (e) {
      return null;
    }
  }

  static void cancelTokenListener() {
    tokenStream?.cancel();
  }
}

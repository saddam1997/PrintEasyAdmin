import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/firebase_options.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    if (kDebugMode) ...[
      dotenv.load(),
    ],
    DBWrapper.i.init(),
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);
  if (kDebugMode) {
    AppUtility.apiKey = dotenv.get('API_KEY', fallback: '');
  } else {
    AppUtility.apiKey = const String.fromEnvironment('API_KEY', defaultValue: '');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OnRise Admin',
        theme: kAppTheme,
        initialRoute: AppPages.initial,
        getPages: AppPages.pages,
        unknownRoute: AppPages.unknownRoute,
      );
}

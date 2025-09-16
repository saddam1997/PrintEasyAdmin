import 'package:get/get.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    startOnInit();
  }

  void startOnInit() {
    if (DBWrapper.i.getValue<bool>(AppKeys.isLoggedIn) ?? false) {
      final time = DateTime.fromMillisecondsSinceEpoch(DBWrapper.i.getValue<int>(AppKeys.sessionTime) ?? 0);
      if (DateTime.now().difference(time).inMinutes < 30) {
        return AppRouter.goToDashboard();
      }
    }
    return AppRouter.goToAuth();
  }
}

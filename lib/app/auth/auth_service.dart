import 'package:firebase_auth/firebase_auth.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AuthService {
  const AuthService._();

  static const AuthService _service = AuthService._();

  static AuthService get i => _service;

  Future<bool> login(String email, String password) async {
    try {
      Utility.showLoader('Logging In');
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      await Future.wait([
        DBWrapper.i.saveValueSecurely(AppKeys.accessToken, token ?? ''),
        DBWrapper.i.saveValue(AppKeys.isLoggedIn, true),
        DBWrapper.i.saveValue(AppKeys.sessionTime, DateTime.now().millisecondsSinceEpoch),
      ]);
      Utility.closeLoader();
      return true;
    } on FirebaseAuthException catch (e) {
      Utility.closeLoader();
      var error = '';
      switch (e.code) {
        case 'invalid-email':
          error = 'Invalid email address';
          break;
        case 'user-not-found':
          error = 'No user found for that email.';
          break;
        case 'wrong-password':
          error = 'Wrong password provided for that user.';
          break;
        case 'invalid-credential':
          error = 'Invalid credentials';
          break;
        default:
          error = 'An undefined error occurred.';
      }
      await Utility.showInfoDialog(DialogModel.error(error));
      return false;
    } catch (e) {
      Utility.closeLoader();
      var error = 'An error occurred. Please try again.';
      await Utility.showInfoDialog(DialogModel.error(error));
      return false;
    }
  }

  Future<void> logout() => Future.wait([
        DBWrapper.i.deleteSecuredValue(AppKeys.accessToken),
        DBWrapper.i.deleteValue(AppKeys.isLoggedIn),
        FirebaseAuth.instance.signOut(),
      ]);
}

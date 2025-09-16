import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const String route = AppRoutes.auth;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 700,
              maxWidth: 600,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GetBuilder<AuthController>(
                builder: (controller) => Form(
                  key: controller.loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Hero(
                        key: ValueKey('AppLogo'),
                        tag: 'app-logo',
                        child: AppLogo(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Admin Login',
                        style: context.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      InputField(
                        label: 'Email',
                        controller: controller.emailTEC,
                        autofillHints: const [AutofillHints.username, AutofillHints.email],
                        textInputType: TextInputType.emailAddress,
                        validator: AppValidators.emailValidator,
                      ),
                      const SizedBox(height: 16),
                      ObxValue<RxBool>(
                          (hidePassword) => InputField(
                                controller: controller.passwordTEC,
                                validator: AppValidators.userName,
                                label: 'Password',
                                autofillHints: const [AutofillHints.password],
                                textInputType: TextInputType.visiblePassword,
                                obscureText: hidePassword.value,
                                obscureCharacter: '*',
                                suffixIcon: IconButton(
                                  onPressed: () => hidePassword.value = !hidePassword.value,
                                  icon: Icon(
                                    hidePassword.value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                  ),
                                ),
                              ),
                          true.obs),
                      const SizedBox(height: 24),
                      AppButton(
                        onTap: controller.onLogin,
                        label: 'Login',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

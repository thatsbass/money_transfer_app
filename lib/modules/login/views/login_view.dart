import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_texts.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppTexts.appName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 40),
              _buildLoginButton(
                title: AppTexts.continueWithGoogle,
                onPressed: controller.handleGoogleSignIn,
                icon: Icons.g_mobiledata,
              ),
              const SizedBox(height: 16),
              _buildLoginButton(
                title: AppTexts.continueWithFacebook,
                onPressed: controller.handleFacebookSignIn,
                icon: Icons.facebook,
              ),
              const SizedBox(height: 16),
              _buildLoginButton(
                title: AppTexts.continueWithPhone,
                onPressed: controller.showPhoneLoginDialog,
                icon: Icons.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String title,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
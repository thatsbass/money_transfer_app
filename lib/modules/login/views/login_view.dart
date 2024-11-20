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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _buildHeader(),
                const SizedBox(height: 60),
                _buildLoginOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.appName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Bienvenue sur votre application de transfert d\'argent sécurisée',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginOptions() {
    return Column(
      children: [
        _buildLoginButton(
          title: AppTexts.continueWithGoogle,
          onPressed: controller.handleGoogleSignIn,
          icon: 'assets/icons/google.png',
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
        const SizedBox(height: 16),
        _buildLoginButton(
          title: AppTexts.continueWithFacebook,
          onPressed: controller.handleFacebookSignIn,
          icon: 'assets/icons/facebook.png',
          backgroundColor: const Color(0xFF1877F2),
          textColor: Colors.white,
        ),
        const SizedBox(height: 16),
        _buildLoginButton(
          title: AppTexts.continueWithPhone,
          onPressed: controller.showPhoneLoginDialog,
          icon: 'assets/icons/phone.png',
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
        ),
        const SizedBox(height: 30),
        Text(
          'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton({
    required String title,
    required VoidCallback onPressed,
    required String icon,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
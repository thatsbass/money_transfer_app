import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../core/constants/app_texts.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  Future<void> handleGoogleSignIn() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        AppTexts.error,
        'Erreur lors de la connexion avec Google',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> handleFacebookSignIn() async {
    try {
      final userCredential = await _authService.signInWithFacebook();
      if (userCredential != null) {
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar(
        AppTexts.error,
        'Erreur lors de la connexion avec Facebook',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showPhoneLoginDialog() {
    final phoneController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text(AppTexts.phone),
        content: TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+261 34 00 000 00',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              handlePhoneSignIn(phoneController.text);
            },
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  Future<void> handlePhoneSignIn(String phoneNumber) async {
    try {
      await _authService.signInWithPhone(
        phoneNumber,
        (verificationId) {
          // Show dialog for OTP verification
          showOTPDialog(verificationId);
        },
        (error) {
          Get.snackbar(
            AppTexts.error,
            error,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        AppTexts.error,
        'Erreur lors de la connexion par téléphone',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showOTPDialog(String verificationId) {
    final otpController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Code de vérification'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            hintText: 'Entrez le code reçu par SMS',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              // Verify OTP and sign in
              // Add verification logic here
              Get.back();
            },
            child: const Text('Vérifier'),
          ),
        ],
      ),
    );
  }
}
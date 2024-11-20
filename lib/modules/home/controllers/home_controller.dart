import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../services/user_service.dart';
import '../../../../services/auth_service.dart';

class HomeController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final AuthService _authService = Get.find<AuthService>();

  final user = Rx<UserModel?>(null);
  final transactions = RxList<TransactionModel>([]);
  final currentIndex = 0.obs;
  final isBalanceVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadTransactions();
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == 3) {
      _showSettingsDialog();
    }
  }

  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Paramètres'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Infos client'),
              onTap: () {
                Get.back();
                Get.toNamed('/client/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Demandes'),
              onTap: () {
                Get.back();
                Get.toNamed('/client/requests');
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Trouver des agences à proximité'),
              onTap: () {
                Get.back();
                Get.toNamed('/client/agencies');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Changer le mot de passe'),
              onTap: () {
                Get.back();
                Get.toNamed('/client/change-password');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () async {
                Get.back();
                await _authService.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadUserData() async {
    try {
      final currentUser = _authService.currentUser.value;
      if (currentUser != null) {
        final userData = await _userService.getUser(currentUser.uid);
        if (userData != null) {
          user.value = userData;
        }
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données utilisateur');
    }
  }

  Future<void> loadTransactions() async {
    transactions.value = [
      TransactionModel(
        amount: 100.0,
        date: '2024-01-20',
        type: 'RECEIVE',
        sender: Sender(firstName: 'John', lastName: 'Doe', phone: '+261340000000'),
      ),
    ];
  }

  void onDepositTap() {
    Get.toNamed('/client/deposit');
  }

  void onWithdrawTap() {
    Get.toNamed('/client/withdraw');
  }

  void onTransferTap() {
    Get.toNamed('/client/transfer');
  }
}

class TransactionModel {
  final double amount;
  final String date;
  final String type;
  final Sender sender;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.type,
    required this.sender,
  });
}

class Sender {
  final String firstName;
  final String lastName;
  final String phone;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}
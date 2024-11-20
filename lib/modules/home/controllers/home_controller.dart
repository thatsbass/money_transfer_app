import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../services/user_service.dart';
import '../../../../services/auth_service.dart';

class HomeController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final AuthService _authService = Get.find<AuthService>();

  final user = Rx<UserModel?>(null);
  final transactions = RxList<TransactionModel>([]);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadTransactions();
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
    // Simuler le chargement des transactions
    // À remplacer par l'appel API réel
    transactions.value = [
      TransactionModel(
        amount: 100.0,
        date: '2024-01-20',
        type: 'RECEIVE',
        sender: Sender(firstName: 'John', lastName: 'Doe', phone: '+261340000000'),
      ),
      // Ajouter d'autres transactions...
    ];
  }

  void onDepositTap() {
    // Implémenter la logique de dépôt
    Get.toNamed('/client/deposit');
  }

  void onWithdrawTap() {
    // Implémenter la logique de retrait
    Get.toNamed('/client/withdraw');
  }

  void onTransferTap() {
    // Implémenter la logique de transfert
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
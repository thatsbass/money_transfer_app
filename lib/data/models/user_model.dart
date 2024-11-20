class UserModel {
  final String id;
  final String nom;
  final String prenom;
  final String adresse;
  final String cin;
  final String telephone;
  final String email;
  final String role;
  final Account account;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.cin,
    required this.telephone,
    required this.email,
    required this.role,
    required this.account,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      adresse: json['adresse'] ?? '',
      cin: json['CIN'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      account: Account.fromJson(json['account'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'CIN': cin,
      'telephone': telephone,
      'email': email,
      'role': role,
      'account': account.toJson(),
    };
  }
}

class Account {
  final double balance;
  final double balanceMax;
  final double balanceMensuel;
  final String status;
  final String qrcode;

  Account({
    required this.balance,
    required this.balanceMax,
    required this.balanceMensuel,
    required this.status,
    required this.qrcode,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      balance: (json['balance'] ?? 0.0).toDouble(),
      balanceMax: (json['balanceMax'] ?? 0.0).toDouble(),
      balanceMensuel: (json['balanceMensuel'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      qrcode: json['qrcode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'balanceMax': balanceMax,
      'balanceMensuel': balanceMensuel,
      'status': status,
      'qrcode': qrcode,
    };
  }
}
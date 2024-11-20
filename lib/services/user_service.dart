import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';


  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Erreur lors de la création de l\'utilisateur: $e';
    }
  }


  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      throw 'Erreur lors de la mise à jour de l\'utilisateur: $e';
    }
  }


  Future<UserModel?> getUser(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Erreur lors de la récupération de l\'utilisateur: $e';
    }
  }


  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Erreur lors de la suppression de l\'utilisateur: $e';
    }
  }

  // Récupérer tous les utilisateurs
  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Erreur lors de la récupération des utilisateurs: $e';
    }
  }
}
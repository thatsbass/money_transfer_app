import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final StorageService _storage = Get.find<StorageService>();

  Rx<User?> currentUser = Rx<User?>(null);
  Rx<UserModel?> currentUserModel = Rx<UserModel?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleAuthChanged);
    super.onInit();
  }

  void _handleAuthChanged(User? user) async {
    try {
      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists && userData.data() != null) {
          currentUserModel.value = UserModel.fromJson(userData.data()!);
          await _storage.saveUser(userData.data()!);
          await _storage.setLoggedIn(true);

          // Redirection basée sur le rôle
          switch (currentUserModel.value?.role) {
            case 'CLIENT':
              Get.offAllNamed('/client/home');
              break;
            case 'DISTRIBUTEUR':
              Get.offAllNamed('/distributor/home');
              break;
            default:
              print('Rôle utilisateur inconnu : ${currentUserModel.value?.role}');
              Get.offAllNamed('/login');
          }
        } else {
          // L'utilisateur existe dans Firebase Auth mais pas dans Firestore
          await _createUserInFirestore(user, 'CLIENT');
        }
      } else {
        currentUserModel.value = null;
        await _storage.clearAll();
        Get.offAllNamed('/login');
      }
    } catch (e) {
      print('Erreur dans _handleAuthChanged: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la récupération des données utilisateur',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


//     Future<String> signInWithGoogle() async {
//     final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuthentication =
//         await googleSignInAccount.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//         accessToken: googleAuthentication.accessToken,
//         idToken: googleAuthentication.idToken);
//     final AuthResult authResult =
//         await firebaseAuth.signInWithCredential(credential);
//     final FirebaseUser user = authResult.user;
//     assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);
//     final FirebaseUser currentUser = await firebaseAuth.currentUser();
//     assert(user.uid == currentUser.uid);
//     print('signInWithGoogle succeeded: $user');
//     return 'signInWithGoogle succeeded: $user';
//   }
// }
Future<UserCredential?> signInWithGoogle() async {
  try {
    isLoading.value = true;

    // Déconnexion préalable
    await Future.wait([
      _googleSignIn.signOut(),
      _auth.signOut(),
    ]);

    // Connexion Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Connexion Google annulée';
    }

    // Obtention des tokens
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      throw 'Impossible d\'obtenir les tokens d\'authentification';
    }

    // Création des credentials Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Connexion Firebase
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      // Vérification de l'utilisateur courant
      final currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);

      // Ajout de l'utilisateur à Firestore
      await _createUserInFirestore(user, 'CLIENT');

      Get.snackbar(
        'Succès',
        'Connexion réussie avec Google',
        snackPosition: SnackPosition.BOTTOM,
      );
      return userCredential;
    }
    return null;
  } on FirebaseAuthException catch (e) {
    _handleFirebaseAuthError(e);
    return null;
  } catch (e) {
    print('Erreur de connexion Google: $e');
    Get.snackbar(
      'Erreur',
      'Erreur lors de la connexion: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
    );
    return null;
  } finally {
    isLoading.value = false;
  }
}


  Future<UserCredential?> signInWithFacebook() async {
    try {
      isLoading.value = true;

      await _facebookAuth.logOut();
      final LoginResult result = await _facebookAuth.login();

      if (result.status != LoginStatus.success) {
        throw 'Connexion Facebook échouée: ${result.status}';
      }

      if (result.accessToken == null) {
        throw 'Token Facebook manquant';
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.token,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _createUserInFirestore(userCredential.user!, 'CLIENT');

      Get.snackbar(
        'Succès',
        'Connexion réussie avec Facebook',
        snackPosition: SnackPosition.BOTTOM,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
      return null;
    } catch (e) {
      print('Erreur de connexion Facebook: $e');
      Get.snackbar(
        'Erreur',
        'Erreur lors de la connexion Facebook: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String) onCodeSent,
    Function(String) onError,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          await _createUserInFirestore(userCredential.user!, 'CLIENT');
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Erreur lors de la vérification du téléphone');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Erreur lors de l\'authentification par téléphone: $e');
      onError('Une erreur est survenue lors de l\'authentification');
    }
  }

  Future<void> verifyOTP(String verificationId, String otp) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _createUserInFirestore(userCredential.user!, 'CLIENT');

      Get.snackbar(
        'Succès',
        'Vérification réussie',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Code de vérification invalide',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createUserInFirestore(User user, String role) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        final names = _parseDisplayName(user.displayName);

        final UserModel newUser = UserModel(
          id: user.uid,
          nom: names['lastName'] ?? '',
          prenom: names['firstName'] ?? '',
          adresse: '',
          cin: '',
          telephone: user.phoneNumber ?? '',
          email: user.email ?? '',
          role: role,
          account: Account(
            balance: 0.0,
            balanceMax: 1000000.0,
            balanceMensuel: 0.0,
            status: 'ACTIVE',
            qrcode: user.uid,
          ),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        currentUserModel.value = newUser;
      }
    } catch (e) {
      print('Erreur création utilisateur Firestore: $e');
      throw 'Erreur lors de la création du profil utilisateur';
    }
  }

  Map<String, String> _parseDisplayName(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return {
        'firstName': '',
        'lastName': ''
      };
    }

    final nameParts = displayName.trim().split(' ');
    return {
      'firstName': nameParts.first,
      'lastName': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : ''
    };
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    print('FirebaseAuthException: ${e.code} - ${e.message}');
    Get.snackbar(
      'Erreur',
      _getFirebaseAuthErrorMessage(e),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'L\'adresse email est invalide';
      case 'user-disabled':
        return 'Ce compte utilisateur a été désactivé';
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Le mot de passe est incorrect';
      default:
        return 'Une erreur inconnue est survenue';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _facebookAuth.logOut();
    currentUserModel.value = null;
    await _storage.clearAll();
    Get.offAllNamed('/login');
  }
}

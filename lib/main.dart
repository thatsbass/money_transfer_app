import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'core/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de Firebase avec les options de configuration
  await Firebase.initializeApp(
    options: FirebaseConfig.firebaseOptions,
  );
  
  // Initialisation du stockage local
  await GetStorage.init();
  
  // Injection des services
  Get.put(StorageService());
  Get.put(AuthService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Money Transfer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
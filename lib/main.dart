import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart';

import 'package:users/core/config/app_config.dart';
import 'package:users/presentation/pages/home_page.dart';
import 'package:users/controllers/user_controller.dart';
import 'package:users/data/repositories/user_repository.dart';
import 'package:users/controllers/expense_controller.dart';
import 'package:users/data/repositories/expense_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final client = AppwriteConfig.initClient();
  final databases = AppwriteConfig.initDatabase(client);

  // Initialize User dependencies
  Get.put(UserRepository(databases));
  Get.put(UserController(repository: Get.find()));

  // Initialize Expense dependencies
  Get.put(ExpenseRepository(databases));
  Get.put(ExpenseController(repository: Get.find()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appwrite Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: false,
      ),
      home: HomePage(),
    );
  }
}

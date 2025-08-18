import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:todo/screens/todo_home_screen.dart';
import 'package:todo/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for using SharedPreferences before runApp()
  Get.put(ApiService());
  final prefs = await SharedPreferences.getInstance(); // Check login state
  final isLogin = prefs.getBool('isLogin') ?? false;
  final name = prefs.getString('name') ?? '';

  runApp(MyApp(isLogin: isLogin, name: name)); // Pass login state
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  final String name;
  const MyApp({super.key, this.isLogin = false, this.name = ''});

  @override
  Widget build(BuildContext context) {
    // Navigate to login screen or home screen based on saved login state

    return GetMaterialApp(
      home:  isLogin ? TodoHomeScreen(name: name) : LoginScreen(),
    );
  }
}

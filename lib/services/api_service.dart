// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/login_request_model.dart';
import 'package:todo/models/login_response_model.dart';
import 'package:todo/models/signup_request_model.dart';
import 'package:todo/models/signup_response_model.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:todo/screens/todo_home_screen.dart';

class ApiService {
  // Private constructor
  ApiService._privateConstructor();

  // Single static instance
  static final ApiService _instance = ApiService._privateConstructor();

  // Factory constructor returns the same instance
  factory ApiService() {
    return _instance;
  }

  final String baseUrl = "https://spring-itpm-api.onrender.com/api";
  final String registerUrl = "/users/register";
  final String validateUrl = "/users/validate";

  // API Methods
  Future<void> signupApi({
    required SignupRequestModel signupRequestModel,
    required BuildContext context,
  }) async {
    Uri loginUrl = Uri.parse(baseUrl + registerUrl);
    debugPrint('loginUrl=====$loginUrl');

    final request = signupRequestModelToJson(signupRequestModel);
    debugPrint('request model=====$request');

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.green,
          ),
        ),
      );
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: request,
      );

      debugPrint('statusCode=====${response.statusCode}');
      debugPrint('response=====${response.body}');
      if (Navigator.canPop(context)) Navigator.pop(context);

      if (response.statusCode == 201) {
        SignupResponseModel signupResponseModel = signupResponseModelFromJson(
          response.body,
        );
        debugPrint('loginResponseModel=====$signupResponseModel');

        if (signupResponseModel.success ?? false) {
          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signup successful!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(signupResponseModel.message ?? 'Signup failed.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (Navigator.canPop(context)) Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> loginApi({
    required LoginRequestModel loginRequestModel,
    required BuildContext context,
  }) async {
    Uri loginUrl = Uri.parse(baseUrl + validateUrl);
    debugPrint('loginUrl=====$loginUrl');

    final request = loginRequestModelToJson(loginRequestModel);
    debugPrint('request model=====$request');

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.green,
          ),
        ),
      );

      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: request,
      );
      debugPrint('statusCode=====${response.statusCode}');
      debugPrint('response=====${response.body}');

      if (Navigator.canPop(context)) Navigator.pop(context);

      if (response.statusCode == 200) {
        LoginResponseModel loginResponseModel = loginResponseModelFromJson(
          response.body,
        );
        debugPrint('loginResponseModel=====$loginResponseModel');

        if (loginResponseModel.isValid ?? false) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isLogin", true);
          await prefs.setString('name', loginResponseModel.user?.name ?? '');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TodoHomeScreen(name: loginResponseModel.user?.name ?? ''),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                loginResponseModel.message ?? 'Invalid login credentials',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unauthorized: Incorrect username or password'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

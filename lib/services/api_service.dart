import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/login_request_model.dart';
import 'package:todo/models/login_response_model.dart';
import 'package:todo/models/signup_request_model.dart';
import 'package:todo/models/signup_response_model.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:todo/screens/todo_home_screen.dart';

class ApiService extends GetxController {
  // Private constructor
  // ApiService._privateConstructor();

  // Single static instance
  // static final ApiService _instance = ApiService._privateConstructor();

  // Factory constructor returns the same instance
  // factory ApiService() {
  //   return _instance;
  // }

  final String baseUrl = "https://spring-itpm-api.onrender.com/api";
  final String registerUrl = "/users/register";
  final String validateUrl = "/users/validate";

  // API Methods
  Future<void> signupApi({
    required SignupRequestModel signupRequestModel,
  }) async {
    Uri signupUrl = Uri.parse('$baseUrl$registerUrl');
    debugPrint('Signup URL: $signupUrl');

    final request = signupRequestModelToJson(signupRequestModel);
    debugPrint('Signup payload: $request');

    try {
      _showLoading();
      final response = await http.post(
        signupUrl,
        headers: {'Content-Type': 'application/json'},
        body: request,
      );

      debugPrint('Signup status code: ${response.statusCode}');
      debugPrint('Signup response: ${response.body}');

      if (response.statusCode == 201) {
        final SignupResponseModel signupResponseModel =
            signupResponseModelFromJson(response.body);
        debugPrint('Signup response model: $signupResponseModel');

        if (signupResponseModel.success ?? false) {
          // Show success snackbar
          _showSnackBar('Signup successful!', isError: false);
          Get.off(() => LoginScreen());
        } else {
          _showSnackBar(signupResponseModel.message ?? 'Signup failed.');
        }
      } else {
        _showSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login error: $e');

      _showSnackBar('Something went wrong. Please try again later.');
    } finally {
      _closeLoading();
    }
  }

  Future<void> loginApi({required LoginRequestModel loginRequestModel}) async {
    Uri loginUrl = Uri.parse('$baseUrl$validateUrl');
    debugPrint('Login URL: $loginUrl');

    final request = loginRequestModelToJson(loginRequestModel);
    debugPrint('Login payload: $request');

    try {
      _showLoading();
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: request,
      );
      debugPrint('Login status code: ${response.statusCode}');
      debugPrint('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final LoginResponseModel loginResponseModel =
            loginResponseModelFromJson(response.body);
        debugPrint('Login response model: $loginResponseModel');

        if (loginResponseModel.isValid ?? false) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isLogin", true);
          await prefs.setString('name', loginResponseModel.user?.name ?? '');

          Get.off(
            () => TodoHomeScreen(name: loginResponseModel.user?.name ?? ''),
          );
          _showSnackBar('Login successful!', isError: false);
        } else {
          _showSnackBar(
            '${loginResponseModel.message ?? 'Login failed.'} Please check your credentials.',
          );
        }
      } else if (response.statusCode == 401) {
        _showSnackBar('Unauthorized: Incorrect username or password');
      } else {
        _showSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Login error: $e');

      _showSnackBar('Something went wrong. Please try again later.');
    } finally {
      _closeLoading();
    }
  }

  /// Show snackBar
  void _showSnackBar(String message, {bool isError = true}) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show loading indicator
  void _showLoading() {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  /// Safe back from dialog
  void _closeLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

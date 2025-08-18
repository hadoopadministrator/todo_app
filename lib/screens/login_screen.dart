import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/models/login_request_model.dart';
import 'package:todo/screens/forgot_password_screen.dart';
import 'package:todo/screens/sign_up_screen.dart';
import 'package:todo/services/api_service.dart';
import 'package:todo/utils/form_validators.dart';
import 'package:todo/widgets/custom_scaffold.dart';
import 'package:todo/widgets/custom_text.dart';
import 'package:todo/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RxBool _obscurePassword = true.obs;
  void _togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _service = Get.find<ApiService>();

  void _submitLoginForm() async {
    if (_formKey.currentState!.validate()) {
      final userId = _userIdController.text.trim();
      final password = _passwordController.text.trim();

      await _service.loginApi(
        loginRequestModel: LoginRequestModel(
          userid: userId,
          password: password,
        ),
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fix the errors',
        backgroundColor: Colors.deepPurpleAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.lock_outline_rounded, color: Colors.green, size: 65),
              SizedBox(height: 20),
              CustomText(
                text: 'Welcome Back',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4),
              CustomText(
                text: 'Log in to your account',
                fontSize: 14,
                color: Colors.grey,
              ),
              SizedBox(height: 35),
              CustomTextFormField(
                controller: _userIdController,
                validator: FormValidators.validateUserId,
                prefixIcon: Icons.account_circle_outlined,
                labelText: 'User ID',
              ),
              SizedBox(height: 10),
              Obx(
                () => CustomTextFormField(
                  controller: _passwordController,
                  validator: FormValidators.validatePassword,
                  prefixIcon: Icons.lock_outline,
                  labelText: 'Password',
                  suffixIcon: _obscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  obscureText: _obscurePassword.value,
                  onSuffixIconTap: _togglePasswordVisibility,
                ),
              ),
              SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    alignment: Alignment.centerRight,
                  ),
                  child: Text('Forgot Password?'),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitLoginForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: CustomText(
                    text: 'Log In',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Don\'t have an account?',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignUpScreen());
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

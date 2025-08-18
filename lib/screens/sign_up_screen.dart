import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/models/signup_request_model.dart';
import 'package:todo/services/api_service.dart';
import 'package:todo/utils/form_validators.dart';
import 'package:todo/widgets/custom_scaffold.dart';
import 'package:todo/widgets/custom_text.dart';
import 'package:todo/widgets/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final RxBool _obscurePassword = true.obs;
  void _togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ApiService _service = Get.find<ApiService>();

  // ON SIGNUP PRESS

  void _submitSignupForm() {
    if (_formKey.currentState!.validate()) {
      final userId = _userIdController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();

      // Debug logs
      debugPrint('UserID: $userId');
      debugPrint('Password: $password');
      debugPrint('Name: $name');
      debugPrint('Email: $email');
      _service.signupApi(
        signupRequestModel: SignupRequestModel(
          userid: userId,
          password: password,
          name: name,
          email: email,
        ),
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fix the errors in the form',
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
              Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.green,
                size: 65,
              ),
              SizedBox(height: 20),
              CustomText(
                text: 'Create an account',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4),
              CustomText(
                text: 'Create an account to get started!',
                fontSize: 14,
                color: Colors.grey,
              ),
              SizedBox(height: 35),
              CustomTextFormField(
                controller: _nameController,
                validator: FormValidators.validateName,
                prefixIcon: Icons.person_outline,
                labelText: 'Name',
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                controller: _userIdController,
                validator: FormValidators.validateUserId,
                prefixIcon: Icons.account_circle_outlined,
                labelText: 'User ID',
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                controller: _emailController,
                validator: FormValidators.validateEmail,
                prefixIcon: Icons.email_outlined,
                labelText: 'Email',
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
        
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitSignupForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: CustomText(
                    text: 'Sign Up',
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
                    text: 'Already have an account?',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: Text('Log In'),
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

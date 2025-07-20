import 'package:flutter/material.dart';
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
  bool _obscurePassword = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // ON SIGNUP PRESS

  void _submitSignupForm() {
    if (_formKey.currentState!.validate()) {
      final userId = userIdController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();
      final email = emailController.text.trim();

      // Debug logs
      debugPrint('UserID: $userId');
      debugPrint('Password: $password');
      debugPrint('Name: $name');
      debugPrint('Email: $email');
      final api = ApiService();
      api.signupApi(
        signupRequestModel: SignupRequestModel(
          userid: userId,
          password: password,
          name: name,
          email: email,
        ),
        context: context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  controller: nameController,
                  validator: FormValidators.validateName,
                  prefixIcon: Icons.person_outline,
                  labelText: 'Name',
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: userIdController,
                  validator: FormValidators.validateUserId,
                  prefixIcon: Icons.account_circle_outlined,
                  labelText: 'User ID',
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: emailController,
                  validator: FormValidators.validateEmail,
                  prefixIcon: Icons.email_outlined,
                  labelText: 'Email',
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: passwordController,
                  validator: FormValidators.validatePassword,
                  prefixIcon: Icons.lock_outline,
                  labelText: 'Password',
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  obscureText: _obscurePassword,
                  onSuffixIconTap: _togglePasswordVisibility,
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
                        Navigator.pop(context);
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
      ),
    );
  }
}

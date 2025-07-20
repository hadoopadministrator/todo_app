import 'package:flutter/material.dart';
import 'package:todo/models/login_request_model.dart';
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
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ON LOGIN PRESS

  void _submitLoginForm() {
    if (_formKey.currentState!.validate()) {
      final userId = userIdController.text.trim();
      final password = passwordController.text.trim();

      // Debug logs
      debugPrint('UserID: $userId');
      debugPrint('Password: $password');
      final api = ApiService();
      api.loginApi(
        loginRequestModel: LoginRequestModel(
          userid: userId,
          password: password,
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

  // void _home({required String name}) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => TodoHomeScreen(name: name)),
  //   );
  // }

  // late final SharedPreferences prefs;
  // Future<void> _initPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  //   final bool isLogin = prefs.getBool('isLogin') ?? false;
  //   final String name = prefs.getString('name') ?? '';
  //   if (isLogin) {
  //     // Redirect to Home Page
  //     _home(name: name);
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _initPrefs();
  // }

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
                  controller: userIdController,
                  validator: FormValidators.validateUserId,
                  prefixIcon: Icons.account_circle_outlined,
                  labelText: 'User ID',
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
                SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password navigation
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/screens/login_screen.dart';
import 'package:todo/utils/form_validators.dart';
import 'package:todo/widgets/custom_scaffold.dart';
import 'package:todo/widgets/custom_text.dart';
import 'package:todo/widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
   void _submitForgotPasswordForm() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Password reset instructions would be sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(()=> LoginScreen());
    } else {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        backgroundColor: Colors.deepPurpleAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              Icon(Icons.lock_reset_outlined, color: Colors.green, size: 65),
              SizedBox(height: 20),
              CustomText(
                text: 'Forgot Password',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10),
              CustomText(
                text: 'Enter your email to receive password reset instructions',
                fontSize: 14,
                color: Colors.grey,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35),
              CustomTextFormField(
                controller: _emailController,
                validator: FormValidators.validateEmail,
                prefixIcon: Icons.email_outlined,
                labelText: 'Email',   
                textInputAction: TextInputAction.done,      
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    _submitForgotPasswordForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: CustomText(
                    text: 'Send',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/auth/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_reset,
                      size: 100,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildPasswordField(passwordController, "Password"),
                    const SizedBox(height: 15),
                    _buildPasswordField(
                        confirmPasswordController, "Confirm Password"),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: onResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.grey.shade400,
                      ),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      obscureText: hintText == "Password"
          ? !_isPasswordVisible
          : !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.grey.shade600),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hintText == "Password"
                ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                : (_isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
            color: Colors.grey.shade600,
          ),
          onPressed: () {
            setState(() {
              if (hintText == "Password") {
                _isPasswordVisible = !_isPasswordVisible;
              } else {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (hintText == "Password") {
          return validatePassword(value ?? "");
        } else {
          return value!.isEmpty ? "Please re-enter password" : null;
        }
      },
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (!regExp.hasMatch(value)) {
      return 'Password must have at least 6 characters, 1 uppercase, 1 lowercase, and 1 number.';
    }
    return null;
  }

  void onResetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/reset_password.php"),
      body: {
        "email": widget.email,
        "password": passwordController.text,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);
          String message = data['message'] ?? 'Unknown error';
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ));
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid server response"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Server error, please try again later"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }
}

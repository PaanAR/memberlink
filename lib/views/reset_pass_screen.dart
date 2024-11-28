import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      appBar: AppBar(
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: const Color.fromARGB(230, 154, 186, 219),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[800],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (val) => validatePassword(val.toString()),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        hintText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[800],
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (val) =>
                          val!.isEmpty ? "Re-enter password" : null,
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      elevation: 5,
                      onPressed: onResetPassword,
                      minWidth: double.infinity,
                      height: 50,
                      color: Colors.blue[800],
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regExp.hasMatch(value)) {
        return 'Please enter valid password. Password must be at least 6 characters long, include an uppercase letter, a lowercase letter, a number, and a special character (e.g., @, #, etc.).';
      } else {
        return null;
      }
    }
  }

  void onResetPassword() {
    String pass = passwordController.text;
    String pass2 = confirmPasswordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password do not match!!!"),
        backgroundColor: Colors.red,
      ));
      return;
    }

    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/reset_password.php"),
      body: {"email": widget.email, "password": pass},
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (content) => const LoginScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ));
          }
        } catch (e) {
          print("Error decoding JSON: $e");
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid server response"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        print('Server error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Server error, please try again later"),
          backgroundColor: Colors.red,
        ));
      }
    });
  }
}

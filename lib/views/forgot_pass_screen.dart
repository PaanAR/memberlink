import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

import 'verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 234, 234),
      appBar: AppBar(
          title: const Text(
            "Forgot Password",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[800],
          iconTheme: const IconThemeData(color: Colors.white)),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.blue[800]),
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (val) => val!.isEmpty ||
                              !val.contains("@") ||
                              !val.contains(".")
                          ? "Enter a valid email"
                          : null,
                    ),
                    const SizedBox(height: 15),
                    MaterialButton(
                      elevation: 5,
                      onPressed: sendOTP,
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

  void sendOTP() async {
    String email = emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter your email"),
        backgroundColor: Colors.red,
      ));
    } else if (await EmailOTP.sendOTP(email: emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has been sent"),
        backgroundColor: Colors.green,
      ));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (content) => VerificationScreen(email: emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP failed sent"), backgroundColor: Colors.red));
    }
  }
}

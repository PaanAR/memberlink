import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isPassword2Visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EE), // Light cream background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFBCB8B1), // Greyish beige
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF8A817C), // Taupe
                  blurRadius: 20,
                  offset: Offset(0, 10),
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
                    Text(
                      'REGISTER',
                      style: GoogleFonts.monoton(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF463F3A), // Dark brown
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: nameController,
                      hintText: "Name",
                      validator: (val) => val!.isEmpty || val.length < 3
                          ? "Name must be longer than 3 characters"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailController,
                      hintText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter an email';
                        }
                        String pattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(val)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: phoneNumController,
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Phone number must contain only numbers';
                        } else if (val.length < 3) {
                          return 'Phone number must be at least 3 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: passwordController,
                      hintText: "Password",
                      isPasswordVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildPasswordField(
                      controller: password2Controller,
                      hintText: "Re-enter Password",
                      isPasswordVisible: _isPassword2Visible,
                      onToggleVisibility: () {
                        setState(() {
                          _isPassword2Visible = !_isPassword2Visible;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      elevation: 8,
                      onPressed: _checkEmailExists,
                      minWidth: double.infinity,
                      height: 50,
                      color: const Color(0xFF463F3A), // Peachy beige
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Already Registered? Login",
                        style: TextStyle(color: Color(0xFF463F3A)), // Taupe
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white, // Set the input box background to white
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF8A817C)), // Taupe
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white, // Set the input box background to white
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF8A817C)), // Taupe
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF8A817C), // Taupe
          ),
        ),
      ),
      validator: validatePassword,
    );
  }

  String? validatePassword(String? value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    } else if (!regex.hasMatch(value)) {
      return 'Password must be at least 6 characters, include uppercase, lowercase, and a number';
    }
    return null;
  }

  void _registerUserDialog() {
    String pass1 = passwordController.text;
    String pass2 = password2Controller.text;

    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Register new account?"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _registerUser() {
    String name = nameController.text;
    String email = emailController.text;
    String phoneNum = phoneNumController.text;
    String password = passwordController.text;

    http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phoneNum": phoneNum,
          "password": password
        }).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> _checkEmailExists() async {
    String email = emailController.text;

    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/check_email.php"),
      body: {"email": email},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "exists") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email is already registered"),
            backgroundColor: Colors.red,
          ));
        } else {
          _registerUserDialog();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error checking email"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error: Unable to check email"),
        backgroundColor: Colors.red,
      ));
    });
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/auth/forgot_pass_screen.dart';
import 'package:mymemberlinks/views/newsletter/news_screen.dart';
import 'package:mymemberlinks/views/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberme = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    loadPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3EE), // Light cream background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/2.png',
                    height: 120,
                    width: 120,
                  ),
                  Text(
                    'Login',
                    style: GoogleFonts.monoton(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF463F3A), // Dark brown
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    emailController,
                    'Email',
                    Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    passwordController,
                    'Password',
                    Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 20),
                  _buildRememberMe(),
                  const SizedBox(height: 40),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Color(0xFF463F3A)), // Taupe
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create New Account?",
                      style: TextStyle(color: Color(0xFF463F3A)), // Taupe
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: const TextStyle(color: Color(0xFF463F3A)), // Dark brown
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8A817C)), // Taupe
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8A817C)), // Taupe
        filled: true,
        fillColor: const Color(0xFFF4F3EE), // Peachy beige
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Color(0xFF463F3A), width: 2), // Dark brown
        ),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF8A817C), // Taupe
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        const Text("Remember me",
            style: TextStyle(color: Color(0xFF463F3A))), // Taupe
        Checkbox(
          value: rememberme,
          onChanged: (bool? value) {
            setState(() {
              rememberme = value ?? false;
              if (rememberme &&
                  emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                storeSharedPrefs(
                    rememberme, emailController.text, passwordController.text);
              } else {
                storeSharedPrefs(false, "", "");
              }
            });
          },
          activeColor: const Color(0xFF463F3A), // Dark brown
          checkColor: const Color(0xFFF4F3EE), // Light cream
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: onLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF463F3A), // Taupe
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: const Color(0xFF463F3A), // Dark brown
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Color(0xFFF4F3EE)), // Light cream
      ),
    );
  }

  void onLogin() {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/login_user.php"),
      body: {"email": email, "password": password},
    ).then((response) {
      try {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Color(0xFF463F3A), // Dark brown
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unexpected response format"),
          backgroundColor: Colors.red,
        ));
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Network error. Please try again later."),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString('email', email);
      prefs.setString('pass', pass);
      prefs.setBool('rememberme', value);
    } else {
      prefs.remove('email');
      prefs.remove('pass');
      prefs.setBool('rememberme', value);
      emailController.text = "";
      passwordController.text = "";
    }
    setState(() {});
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString("email") ?? "";
    passwordController.text = prefs.getString("pass") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}

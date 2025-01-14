import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/views/auth/forgot_pass_screen.dart';
import 'package:mymemberlinks/views/newsletter/news_screen.dart';
import 'package:mymemberlinks/views/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlinks/model/user.dart';

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
      backgroundColor: const Color(0xFFF4F3EE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFBCB8B1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF8A817C),
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
                        color: const Color(0xFF463F3A),
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
                        style: TextStyle(color: Color(0xFF463F3A)),
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
                        style: TextStyle(color: Color(0xFF463F3A)),
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      style: const TextStyle(color: Color(0xFF463F3A)),
      keyboardType:
          isPassword ? TextInputType.text : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8A817C)),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8A817C)),
        filled: true,
        fillColor: const Color(0xFFF4F3EE),
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
          borderSide: const BorderSide(color: Color(0xFF463F3A), width: 2),
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
                  color: const Color(0xFF8A817C),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        const Text("Remember me", style: TextStyle(color: Color(0xFF463F3A))),
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
          activeColor: const Color(0xFF463F3A),
          checkColor: const Color(0xFFF4F3EE),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: onLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF463F3A),
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: const Color(0xFF463F3A),
      ),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Color(0xFFF4F3EE)),
      ),
    );
  }

  void onLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Check if either the email or password is empty
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return; // Exit early to avoid making the network request
    }

    try {
      // Make the network request only if the fields are not empty
      final response = await http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/login_user.php"),
        body: {"email": email, "password": password},
      );

      // Debugging the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        print("/nbefore var data"); // Add this to debug
        print('Raw Response: ${response.body}');
        var data = jsonDecode(response.body);
        print(data["data"]);
        print("/n after var data");
        if (data['status'] == "success") {
          print("Login success");
          User user = User.fromJson(data['data']);
          // Parse user data here
          print('User ID: ${user.userId}');
          print('Username: ${user.username}');
          print('Email: ${user.userEmail}');
          print('Phone: ${user.phoneNumber}');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Color(0xFF463F3A),
          ));

          // Navigate to the MainScreen after a successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(user: user),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // Handle non-200 response status code
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      // Handle any network errors
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Network error. Please try again later."),
        backgroundColor: Colors.red,
      ));
    }
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

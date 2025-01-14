import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mymemberlinks/views/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EmailOTP.config(
    appName: 'MyMemberLink',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v2,
    otpLength: 4,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

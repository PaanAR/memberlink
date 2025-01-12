import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:mymemberlinks/views/splash_screen.dart';
import 'package:mymemberlinks/views/membership/membership_screen.dart';

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
    return MaterialApp(
      navigatorObservers: [RouteObserver<PageRoute>()],
      home: SplashScreen(),
      routes: {
        '/membership': (context) => const MembershipScreen(),
      },
      // Add this to prevent the app from going back to splash screen
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => const MembershipScreen());
        }
        return null;
      },
    );
  }
}

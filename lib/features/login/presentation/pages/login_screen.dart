import 'package:flutter/material.dart';
import 'package:leaptech_plus/features/login/presentation/widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginScreenBody(),
    );
  }
}

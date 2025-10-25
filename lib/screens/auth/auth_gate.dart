import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/widgets/app_bottom_nav.dart';
import './sign_in_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 🌀 Mientras Firebase verifica el estado del usuario
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ Usuario logeado → Pantalla principal
        if (snapshot.hasData) {
          Future.microtask(() {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AppBottomNav()),
              (route) => false,
            );
          });
          return const SizedBox.shrink();
        }

        // ❌ Usuario no logeado → Pantalla de inicio de sesión
        return const SignInScreen();
      },
    );
  }
}

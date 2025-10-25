import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/widgets/app_bottom_nav.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/news_provider.dart';

// Screens
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/activity/activity_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/news/news_screen.dart';
import 'screens/shop/cart_screen.dart';
import 'screens/shop/product_detail_screen.dart';
import 'screens/shop/checkout_success_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const RuntahPediaApp(),
    ),
  );
}

class RuntahPediaApp extends StatelessWidget {
  const RuntahPediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuntahPedia',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AuthGate(),
      routes: {
        SignInScreen.route: (_) => const SignInScreen(),
        SignUpScreen.route: (_) => const SignUpScreen(),
        ShopScreen.route: (_) => const ShopScreen(),
        NewsScreen.route: (_) => NewsScreen(),
        CartScreen.route: (_) => const CartScreen(),
        CheckoutSuccessScreen.route: (_) => const CheckoutSuccessScreen(),
        ActivityScreen.route: (_) => const ActivityScreen(),
        MessagesScreen.route: (_) => const MessagesScreen(),
        AccountScreen.route: (_) => const AccountScreen(),
      },
    );
  }
}

/// Controla si el usuario está autenticado o no
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const AppBottomNav();
        }

        return const SignInScreen();
      },
    );
  }
}

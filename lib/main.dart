import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Page de connexion
import 'screens/home_page.dart'; // Page d'accueil
import 'screens/verify_email_screen.dart'; // Page de vérification de l'email
import 'screens/reset_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(), // Gestion de la redirection
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/verify-email': (context) => VerifyEmailScreen(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user != null) {
            if (user.emailVerified) {
              return HomePage(); // Accès à l'application
            } else {
              return VerifyEmailScreen(); // Redirection vers la page de vérification
            }
          }
          return LoginScreen(); // Si non connecté, affiche la page de login
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

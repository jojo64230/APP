import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isEmailSent = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      setState(() {
        _isEmailSent = true;
      });
    }
  }

  Future<void> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vérification de l\'email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Un email de vérification a été envoyé à votre adresse.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_isEmailSent)
              Text(
                'Veuillez vérifier votre boîte mail puis cliquez sur le bouton ci-dessous.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkEmailVerified,
              child: Text('J\'ai vérifié mon email'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _sendVerificationEmail,
              child: Text('Renvoyer l\'email de vérification'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _logout,
              child: Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'home_view.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

  class SignUpView extends StatefulWidget {
    @override
    _SignUpViewState createState() => _SignUpViewState();

    }

    class _SignUpViewState extends State<SignUpView> {

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
      @override
      void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
        centerTitle: true,
        backgroundColor: Color(0xFFE19F0C),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            _SubmitButton(
                emailController: _emailController,
                passwordController: _passwordController),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _SubmitButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  final AuthService _authService = FirebaseAuthService(
    authService: FirebaseAuth.instance,
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final email = widget.emailController.text;
          final password = widget.passwordController.text;
          await _authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFFE19F0C)),
      ),
      child: const Text('Créer mon compte'),
    );
  }
}
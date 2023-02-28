import 'package:braderie_ppe/profil.dart';
import 'package:flutter/foundation.dart';
import 'signup_view.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();

}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
        centerTitle: true,
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
            const SizedBox(height: 30.0),
            _CreateAccountButton(),
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
          await _authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Profil()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
      child: const Text('Login'),
    );
  }
}


class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpView(),
          ),
        );
      },
      child: const Text('Create Account'),
    );
  }
}
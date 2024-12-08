import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/UI/register.dart';
import 'package:mob3_login_022_endah/auth/service_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // String _errorMessage = "";

  // Future<void> _login() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            // if (_errorMessage.isNotEmpty)
            //   Text(
            //     _errorMessage,
            //     style: const TextStyle(color: Colors.red),
            //   ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await signin(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
              },
              child: const Text("Login"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Register(
                              title: '',
                            )),
                  );
                },
                child: const Text('Belum Memiliki Akun ?'))
          ],
        ),
      ),
    );
  }
}

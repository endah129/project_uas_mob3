import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/auth/service_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key, required String title});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController2 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final String _errorMessage = ""; // ini variable ga pernah berubah

  // Future<void> _login() async {} // ini ga ngapa2in

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Sekarang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController2,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController2,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await signup(
                    email: _emailController2.text,
                    password: _passwordController2.text,
                    context: context);
              },
              child: const Text("Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}

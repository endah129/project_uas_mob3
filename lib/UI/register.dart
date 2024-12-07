import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/auth/serviceAuth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key, required String title});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController2 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorMessage = "";

  Future<void> _login() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Sekarang")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController2,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController2,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signup(
                    email: _emailController2.text,
                    password: _passwordController2.text,
                    context: context
                  );
                },
              child: Text("Daftar"),
              
            ),
          ],
        ),
      ),
    );
  }
}
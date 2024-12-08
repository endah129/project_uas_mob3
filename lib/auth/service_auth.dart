import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/UI/login.dart';
import 'package:mob3_login_022_endah/dasboard/Dasboard.dart';

class AuthService {
  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update nama pengguna
      await userCredential.user?.updateDisplayName(username);

      _showSnackBar(
        context: context,
        message: 'Registrasi berhasil!',
        color: Colors.blue.shade600,
        icon: Icons.check_circle_outline,
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigasi ke layar login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      _showSnackBar(
        context: context,
        message: message,
        color: Colors.red.shade400,
        icon: Icons.error_outline,
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      _showSnackBar(
        context: context,
        message: 'Login berhasil!',
        color: Colors.blue.shade600,
        icon: Icons.check_circle_outline,
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      // Navigasi ke dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  DashboardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String message = _getAuthErrorMessage(e.code);
      _showSnackBar(
        context: context,
        message: message,
        color: Colors.red.shade400,
        icon: Icons.error_outline,
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// Menampilkan SnackBar
  void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: 180,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(milliseconds: 2000),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.45,
          left: 120,
          right: 120,
        ),
      ),
    );
  }

  /// Mendapatkan pesan error dari kode FirebaseAuthException
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password terlalu lemah\nSetidaknya 8 karakter';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Email tidak valid';
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Password salah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk menangkap event keyboard
import 'login.dart'; // Pastikan rute ini mengarah ke lokasi file login.dart Anda

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _loadingFinished = false; // Status apakah loading selesai
  final FocusNode _focusNode = FocusNode(); // Fokus untuk menangkap input keyboard

  @override
  void initState() {
    super.initState();
    // Simulasi loading selesai setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _loadingFinished = true;
      });
    });
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter &&
              _loadingFinished) {
            _navigateToLogin(); // Panggil navigasi saat Enter ditekan dan loading selesai
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade700, // Warna biru gelap
                Colors.blue.shade500, // Biru lebih terang
                Colors.purple.shade400, // Ungu cerah
                Colors.pink.shade300, // Pink lembut
                Colors.orange.shade200, // Oranye terang
              ],
              stops: const [0.0, 0.3, 0.6, 0.8, 1.0], // Mengatur titik peralihan warna
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ganti ikon dengan gambar dari folder assets
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade300.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/mobile.png', // Gambar dari folder assets
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'APLIKASI SIMPAN PINJAM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mengelola keuangan lebih mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 40),
                // Tampilkan loading jika belum selesai
                if (!_loadingFinished)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                if (!_loadingFinished) const SizedBox(height: 20),
                // Tampilkan tombol setelah loading selesai
                if (_loadingFinished)
                  ElevatedButton(
                    onPressed: _navigateToLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Menuju Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

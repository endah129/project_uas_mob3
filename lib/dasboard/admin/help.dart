import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  // Fungsi untuk membuka WhatsApp dengan pesan otomatis
  void _launchWhatsApp() async {
    const phoneNumber = '+6282339542002';  // Ganti dengan nomor WhatsApp Anda
    const message = 'Halo, saya membutuhkan bantuan dengan aplikasi simpan pinjam.';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Panduan Penggunaan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade300,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "1. Masuk ke aplikasi menggunakan akun Anda.\n"
                    "2. Setelah login, Anda akan diarahkan ke dashboard utama.\n"
                    "3. Untuk menambahkan data anggota, pilih 'Input Data Anggota'.\n"
                    "4. Untuk melihat pinjaman, pilih 'Data Pinjaman'.\n"
                    "5. Untuk melihat pembayaran, pilih 'Data Pembayaran'.\n"
                    "6. Jika ada kesulitan, Anda bisa mengakses halaman ini untuk bantuan.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Kontak Bantuan",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade300,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jika Anda membutuhkan bantuan lebih lanjut, silakan hubungi kami di:",
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.messenger_outline, color: Colors.green, size: 24),
                          SizedBox(width: 10),
                          Text(
                            "+6282339542002",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _launchWhatsApp,
                          icon: const Icon(Icons.messenger_outline),
                          label: const Text("Hubungi via WhatsApp"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

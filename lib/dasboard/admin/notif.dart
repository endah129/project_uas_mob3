import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          // Mengambil data dari koleksi anggota dan urutkan berdasarkan createdAt
          FirebaseFirestore.instance
              .collection('anggota')
              .orderBy('createdAt', descending: true) // Urutkan berdasarkan createdAt terbaru
              .get(),
          // Mengambil data dari koleksi pinjaman dan urutkan berdasarkan createdAt
          FirebaseFirestore.instance
              .collection('pinjaman')
              .orderBy('createdAt', descending: true) // Urutkan berdasarkan createdAt terbaru
              .get(),
          // Mengambil data dari koleksi pembayaran dan urutkan berdasarkan createdAt
          FirebaseFirestore.instance
              .collection('pembayaran')
              .orderBy('createdAt', descending: true) // Urutkan berdasarkan createdAt terbaru
              .get(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan.'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data.'));
          }

          // Ambil data dari snapshot
          List<Map<String, String>> notifikasi = [];

          // Menambahkan data anggota
          var anggotaSnapshot = snapshot.data![0];
          for (var doc in anggotaSnapshot.docs) {
            notifikasi.add({
              'title': 'Anggota Baru',
              'subtitle': 'Nama anggota: ${doc['nama']}',
            });
          }

          // Menambahkan data pinjaman
          var pinjamanSnapshot = snapshot.data![1];
          for (var doc in pinjamanSnapshot.docs) {
            notifikasi.add({
              'title': 'Pinjaman Baru',
              'subtitle': 'Nama Peminjam: ${doc['nama']}, Detail pinjaman: ${doc['jumlahPinjaman']}',
            });
          }

          // Menambahkan data pembayaran
          var pembayaranSnapshot = snapshot.data![2];
          for (var doc in pembayaranSnapshot.docs) {
            notifikasi.add({
              'title': 'Pembayaran Diterima',
              'subtitle': 'Nama Peminjam: ${doc['nama']}, Detail pembayaran: ${doc['jumlahPembayaran']}',
            });
          }

          return ListView.builder(
            itemCount: notifikasi.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blueAccent),
                  title: Text(notifikasi[index]['title']!),
                  subtitle: Text(notifikasi[index]['subtitle']!),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Tambahkan aksi ketika item notifikasi ditekan
                  },
                ),
              );
            },
          );
        }
      ),
    );
  }
}

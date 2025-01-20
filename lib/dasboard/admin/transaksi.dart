import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Fungsi untuk memformat tanggal dari string ke format 'yyyy-MM-dd'
String formatDate(String dateStr) {
  try {
    final DateTime date = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(date);
  } catch (e) {
    return 'Invalid date';
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Komponen untuk menampilkan daftar transaksi
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun daftar transaksi
  Widget _buildTransactionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pinjaman') // Stream data dari koleksi 'pinjaman'
          .snapshots(),
      builder: (context, pinjamanSnapshot) {
        if (pinjamanSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (pinjamanSnapshot.hasError) {
          return const Center(child: Text('Error fetching pinjaman data'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pembayaran') // Stream data dari koleksi 'pembayaran'
              .snapshots(),
          builder: (context, pembayaranSnapshot) {
            if (pembayaranSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (pembayaranSnapshot.hasError) {
              return const Center(child: Text('Error fetching pembayaran data'));
            }

            // Ambil dokumen dari koleksi 'pinjaman' dan 'pembayaran'
            final pinjamanDocs = pinjamanSnapshot.data?.docs ?? [];
            final pembayaranDocs = pembayaranSnapshot.data?.docs ?? [];

            // Proses dan gabungkan semua transaksi
            final allTransactions = [
              ...pinjamanDocs.map((doc) => {
                    'nama': doc['nama'] ?? 'Unknown',
                    'jumlah': _parseAmount(doc['jumlahPinjaman']),
                    'tanggal': _parseDate(doc['tanggalPinjaman']),
                    'type': 'Pinjaman',
                  }),
              ...pembayaranDocs.map((doc) => {
                    'nama': doc['nama'] ?? 'Unknown',
                    'jumlah': _parseAmount(doc['jumlahPembayaran']),
                    'tanggal': _parseDate(doc['tanggalPembayaran']),
                    'type': 'Pembayaran',
                  }),
            ];

            // Sorting transaksi berdasarkan tanggal terbaru
            allTransactions.sort((a, b) {
              final DateTime dateA = DateTime.parse(a['tanggal']);
              final DateTime dateB = DateTime.parse(b['tanggal']);
              return dateB.compareTo(dateA); // Descending order
            });

            // Tampilkan data dalam ListView dengan desain kartu
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                final transaction = allTransactions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['nama'],
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: transaction['type'] == 'Pinjaman'
                                ? Colors.blueAccent
                                : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Jumlah : ${transaction['jumlah']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: transaction['type'] == 'Pinjaman'
                                ? Colors.blueAccent
                                : Colors.green,
                          ),
                        ),
                        Text(
                          'Type: ${transaction['type']}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Tanggal: ${transaction['tanggal']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Fungsi untuk memproses jumlah dari string ke format angka
  static String _parseAmount(dynamic amount) {
    if (amount is String) {
      // Hilangkan titik pada string dan ubah menjadi angka
      return amount.replaceAll('.', '');
    }
    return amount.toString(); // Jika sudah angka, konversi langsung ke string
  }

  // Fungsi untuk memproses tanggal
  static String _parseDate(dynamic date) {
    if (date is String) {
      return formatDate(date);
    }
    return 'Invalid date'; // Penanganan jika format tidak valid
  }
}

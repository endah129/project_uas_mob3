import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDataPinjaman extends StatefulWidget {
  final Function(Map<String, Object>) onSaveData; // Menggunakan Map<String, Object>

  const InputDataPinjaman({Key? key, required this.onSaveData, required Map existingData}) : super(key: key);

  @override
  _InputDataPinjamanState createState() => _InputDataPinjamanState();
}

class _InputDataPinjamanState extends State<InputDataPinjaman> {
  final _formKey = GlobalKey<FormState>();

  // Kontroler untuk form input
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _jumlahPinjamanController = TextEditingController();

  DateTime? _tanggalPinjaman;
  DateTime? _tanggalPembayaran;

  Future<void> _pilihTanggalPinjaman() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Tidak boleh memilih sebelum tanggal hari ini
      lastDate: DateTime.now().add(const Duration(days: 1)), // Maksimal 1 hari setelah sekarang
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalPinjaman) {
      setState(() {
        _tanggalPinjaman = picked;
      });
    }
  }


  Future<void> _pilihTanggalPengembalian() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _tanggalPinjaman ?? DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalPembayaran) {
      setState(() {
        _tanggalPembayaran = picked;
      });
    }
  }

  Future<int> _getSaldoAdmin() async {
    try {
      // Ambil saldo dari Firestore (di koleksi 'saldo' dan dokumen 'admin')
      final snapshot = await FirebaseFirestore.instance.collection('saldo').doc('admin').get();
      if (snapshot.exists) {
        return snapshot.data()?['saldo'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching saldo: $e');
      return 0;
    }
  }

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      final jumlahPinjaman = _jumlahPinjamanController.text.isEmpty
          ? '0'
          : _jumlahPinjamanController.text;

      // Ambil saldo admin dari Firestore
      int saldoAdmin = await _getSaldoAdmin();
      int jumlahPinjamanInt = int.parse(jumlahPinjaman);

      if (saldoAdmin >= jumlahPinjamanInt) {
        final data = {
          'nama': _namaController.text,
          'nik': _nikController.text,
          'alamat': _alamatController.text,
          'email': _emailController.text,
          'tanggalPinjaman': _tanggalPinjaman!.toLocal().toString().split(' ')[0],
          'tanggalPembayaran': _tanggalPembayaran!.toLocal().toString().split(' ')[0],
          'jumlahPinjaman': NumberFormat("#,###", "id_ID").format(jumlahPinjamanInt),
          'createdAt': FieldValue.serverTimestamp(), // Menambahkan timestamp otomatis
        };

        try {
          // Simpan data pinjaman ke Firestore
          await FirebaseFirestore.instance.collection('pinjaman').add(data);

          // Update saldo admin setelah peminjaman
          await FirebaseFirestore.instance.collection('saldo').doc('admin').update({
            'saldo': FieldValue.increment(-jumlahPinjamanInt), // Mengurangi saldo sesuai jumlah pinjaman
          });

          widget.onSaveData(data);

          // Tampilkan notifikasi sukses
          _showDialog(context, 'Data berhasil disimpan!', true);

          _resetForm();
        } catch (error) {
          // Tampilkan notifikasi error
          _showDialog(context, 'Terjadi kesalahan saat menyimpan data!', false);
        }
      } else {
        _showDialog(context, 'Saldo tidak cukup untuk peminjaman!', false);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _namaController.clear();
    _alamatController.clear();
    _nikController.clear();
    _emailController.clear();
    _jumlahPinjamanController.clear();
    setState(() {
      _tanggalPinjaman = null;
      _tanggalPembayaran = null;
    });
  }

  void _showDialog(BuildContext context, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 15),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Formulir Pendaftaran Pinjaman',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextFormField(
                      controller: _namaController,
                      label: 'Nama Lengkap',
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      controller: _nikController,
                      label: 'Nomor Induk Kependudukan (NIK)',
                      icon: Icons.card_membership,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty || value.length != 16 
                        ? 'NIK harus 16 digit' 
                        : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      controller: _alamatController,
                      label: 'Alamat Lengkap',
                      icon: Icons.home,
                      validator: (value) => value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty || !RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)
                        ? 'Masukkan email yang valid'
                        : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextFormField(
                      controller: _jumlahPinjamanController,
                      label: 'Jumlah Pinjaman (Rupiah)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Jumlah pinjaman tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildDatePickerRow(
                      label: 'Tanggal Pinjaman',
                      date: _tanggalPinjaman,
                      onPressed: _pilihTanggalPinjaman,
                    ),
                    const SizedBox(height: 15),
                    _buildDatePickerRow(
                      label: 'Tanggal Pengembalian',
                      date: _tanggalPembayaran,
                      onPressed: _pilihTanggalPengembalian,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _simpanData,
                      child: const Text(
                        'Daftar Pinjaman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDatePickerRow({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            date == null 
              ? '$label: Belum dipilih' 
              : '$label: ${date.toLocal().toString().split(' ')[0]}',
            style: TextStyle(
              color: date == null ? Colors.grey : Colors.black87,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
          onPressed: onPressed,
          child: const Text(
            'Pilih',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

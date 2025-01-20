import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputDataAnggota extends StatefulWidget {
  final Function(Map<String, Object>) onSaveData; // Menggunakan Map<String, Object>

  const InputDataAnggota({Key? key, required this.onSaveData, required Map existingData}) : super(key: key);


  @override
  _InputDataAnggotaState createState() => _InputDataAnggotaState();
}

class _InputDataAnggotaState extends State<InputDataAnggota> {
  final _formKey = GlobalKey<FormState>();

  // Kontroler untuk form input
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  DateTime? _tanggalBergabung;
  DateTime? _tanggalLahir;

  Future<void> _pilihTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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
    if (picked != null && picked != _tanggalBergabung) {
      setState(() {
        _tanggalBergabung = picked;
      });
    }
  }

  Future<void> _pilihTanggalLahir() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
        _tanggalLahirController.text = _tanggalLahir!.toLocal().toString().split(' ')[0];
      });
    }
  }

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'email': _emailController.text,
        'nik': _nikController.text,
        'tanggalLahir': _tanggalLahir!.toLocal().toString().split(' ')[0],
        'tanggalBergabung': _tanggalBergabung!.toLocal().toString().split(' ')[0],
        'createdAt': FieldValue.serverTimestamp(), // Menambahkan timestamp otomatis
      };

      try {
        // Simpan data ke Firestore
        await FirebaseFirestore.instance.collection('anggota').add(data);

        widget.onSaveData(data);

        // Tampilkan notifikasi sukses
        _showDialog(context, 'Data berhasil disimpan!', true);

        _resetForm();
      } catch (error) {
        // Tampilkan notifikasi error
        _showDialog(context, 'Terjadi kesalahan saat menyimpan data!', false);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _namaController.clear();
    _alamatController.clear();
    _emailController.clear();
    _nikController.clear();
    _tanggalLahirController.clear();
    setState(() {
      _tanggalBergabung = null;
      _tanggalLahir = null;
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
                      'Formulir Pendaftaran Anggota',
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
                    _buildDateField(
                      controller: _tanggalLahirController,
                      label: 'Tanggal Lahir',
                      onTap: _pilihTanggalLahir,
                      validator: (value) => _tanggalLahir == null 
                        ? 'Pilih tanggal lahir' 
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
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Nomor kontak tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 15),
                    _buildDatePickerRow(
                      label: 'Tanggal Bergabung',
                      date: _tanggalBergabung,
                      onPressed: _pilihTanggal,
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
                        'Daftar Anggota',
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

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      readOnly: true,
      onTap: onTap,
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

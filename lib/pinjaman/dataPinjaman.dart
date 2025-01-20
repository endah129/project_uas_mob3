import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/pinjaman/inputPinjaman.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

class DataPinjamanScreen extends StatefulWidget {
  const DataPinjamanScreen({super.key});

  @override
  _DataPinjamanScreenState createState() => _DataPinjamanScreenState();
}

class _DataPinjamanScreenState extends State<DataPinjamanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _updatePinjaman(String id, Map<String, dynamic> data) async {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: data['nama']);
    final nikController = TextEditingController(text: data['nik']);
    final alamatController = TextEditingController(text: data['alamat']);
    final emailController = TextEditingController(text: data['email'] ?? '');

    String status = data['status'] ?? 'Lunas';

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Update Data Pinjaman',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: namaController,
                      label: 'Nama Peminjam',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: nikController,
                      label: 'NIK',
                      icon: Icons.badge,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: alamatController,
                      label: 'Alamat Lengkap',
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: status,
                      items: ['Lunas', 'Tidak Lunas'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        status = newValue!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Status',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Status harus dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FirebaseFirestore.instance.collection('pinjaman').doc(id).update({
                                'nama': namaController.text,
                                'nik': nikController.text,
                                'alamat': alamatController.text,
                                'email': emailController.text,
                                'status': status,
                              }).then((value) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Data berhasil diperbarui!')),
                                );
                              });
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          label: const Text(
                            'Batal',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade800),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Future<void> _deletePinjaman(String id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pinjaman'),
        content: const Text('Apakah Anda yakin ingin menghapus Pinjaman ini?'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('pinjaman').doc(id).delete().then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Hapus'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pinjaman'),
        backgroundColor: Colors.blue.shade600,
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Client Data'),
            Tab(text: 'Submit Form'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or address...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('pinjaman').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final data = snapshot.data?.docs;

                    final filteredData = data?.where((doc) {
                      final memberData = doc.data() as Map<String, dynamic>;
                      final nama = (memberData['nama'] ?? '').toLowerCase();
                      final alamat = (memberData['alamat'] ?? '').toLowerCase();
                      return nama.contains(searchQuery) || alamat.contains(searchQuery);
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: filteredData == null || filteredData.isEmpty
                          ? const Center(
                              child: Text(
                                'No matching data found',
                                style: TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final memberData = filteredData[index].data() as Map<String, dynamic>;
                                final id = filteredData[index].id;
                                final status = memberData['status'] ?? 'Tidak Lunas';
                                final tanggalPinjaman = memberData['tanggalPinjaman'] ?? '';
                                final tanggalPengembalian = memberData['tanggalPengembalian'] ?? '';
                                final jumlahPinjaman = memberData['jumlahPinjaman'] ?? '';

                                // Format tanggal
                                String formattedTanggalPinjaman = '';
                                if (tanggalPinjaman.isNotEmpty) {
                                  formattedTanggalPinjaman = DateFormat('dd MMM yyyy').format(DateTime.parse(tanggalPinjaman));
                                }
                                
                                String formattedTanggalPengembalian = '';
                                if (tanggalPengembalian.isNotEmpty) {
                                  formattedTanggalPengembalian = DateFormat('dd MMM yyyy').format(DateTime.parse(tanggalPengembalian));
                                }

                                // Format jumlah pinjaman
                                double? jumlah = double.tryParse(jumlahPinjaman.replaceAll('.', ''));

                                if (jumlah != null) {
                                    print(jumlah.isNegative); // Gunakan isNegative di sini
                                } else {
                                    print("Error: Nilai tidak valid");
                                }

                                // Pilih warna berdasarkan status
                                final backgroundColor = status == 'Lunas'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100;

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  color: backgroundColor, // Terapkan warna di sini
                                  child: ListTile(
                                    title: Text(
                                      memberData['nama'] ?? 'Nama Tidak Tersedia',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          memberData['alamat'] ?? 'Alamat Tidak Tersedia',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Status: $status',
                                          style: TextStyle(
                                            color: status == 'Lunas'
                                                ? Colors.green.shade800
                                                : Colors.red.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Tanggal Pinjaman: $formattedTanggalPinjaman',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Tanggal Pengembalian: $formattedTanggalPengembalian',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Jumlah Pinjaman: $jumlah',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _updatePinjaman(id, memberData),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deletePinjaman(id),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: InputDataPinjaman(
                    onSaveData: (data) {},
                    existingData: const {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

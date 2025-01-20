import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/data_anggota/inputAnggota.dart';

class DataAnggotaScreen extends StatefulWidget {
  const DataAnggotaScreen({super.key});

  @override
  _DataAnggotaScreenState createState() => _DataAnggotaScreenState();
}

class _DataAnggotaScreenState extends State<DataAnggotaScreen> with SingleTickerProviderStateMixin {
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

  Future<void> _updateAnggota(String id, Map<String, dynamic> data) async {
    final _formKey = GlobalKey<FormState>();
    final _namaController = TextEditingController(text: data['nama']);
    final _nikController = TextEditingController(text: data['nik']);
    final _tanggalLahirController = TextEditingController(text: data['tanggalLahir']);
    final _alamatController = TextEditingController(text: data['alamat']);
    final _emailController = TextEditingController(text: data['email'] ?? '');

    String status = data['status'] ?? 'Aktif';
    DateTime? selectedDate = data['tanggalLahir'] != null
        ? DateTime.tryParse(data['tanggalLahir'])
        : null;

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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Update Data Anggota',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Anggota',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: _nikController,
                      label: 'NIK',
                      icon: Icons.badge,
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          selectedDate = picked;
                          _tanggalLahirController.text =
                              '${picked.year}-${picked.month}-${picked.day}';
                        }
                      },
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _tanggalLahirController,
                          label: 'Tanggal Lahir',
                          icon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat Lengkap',
                      icon: Icons.home,
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: status,
                      items: ['Aktif', 'Tidak Aktif'].map((String value) {
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
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseFirestore.instance.collection('anggota').doc(id).update({
                                'nama': _namaController.text,
                                'nik': _nikController.text,
                                'tanggalLahir': _tanggalLahirController.text,
                                'alamat': _alamatController.text,
                                'email': _emailController.text,
                                'status': status,
                              }).then((value) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Data berhasil diperbarui!')),
                                );
                              });
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            'Batal',
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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

  Future<void> _deleteAnggota(String id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Anggota'),
        content: Text('Apakah Anda yakin ingin menghapus anggota ini?'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('anggota').doc(id).delete().then((value) {
                Navigator.of(context).pop();
              });
            },
            child: Text('Hapus'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Anggota'),
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
                    prefixIcon: Icon(Icons.search),
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
                  stream: FirebaseFirestore.instance.collection('anggota').snapshots(),
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
                                final status = memberData['status'] ?? 'Tidak Aktif';

                                // Pilih warna berdasarkan status
                                final backgroundColor = status == 'Aktif'
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
                                        SizedBox(height: 5),
                                        Text(
                                          'Status: $status',
                                          style: TextStyle(
                                            color: status == 'Aktif'
                                                ? Colors.green.shade800
                                                : Colors.red.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => _updateAnggota(id, memberData),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deleteAnggota(id),
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
                  child: InputDataAnggota(
                    onSaveData: (data) {},
                    existingData: {},
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

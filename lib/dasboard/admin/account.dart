import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  bool _isEditing = false; // Default mode: tidak dalam mode edit


  String _selectedGender = 'Laki-Laki'; // Default value for gender dropdown
  String _selectedCity = 'Mataram'; // Default value for city dropdown
  String _selectedUniversity = 'Universitas Bumigora'; // Default value
  String _getAvatarAssetPath() {
    final avatarPath = _selectedGender == 'Laki-Laki'
        ? 'assets/images/male.png'
        : 'assets/images/female.png';
    print('Avatar path: $avatarPath'); // Log untuk memastikan path benar
    return avatarPath;
  }


  List<String> _indonesiaCities = [
    'Jakarta', 'Surabaya', 'Bandung', 'Medan', 'Bekasi', 'Depok', 'Tangerang', 'Semarang', 'Makassar', 
    'Palembang', 'Bogor', 'Padang', 'Malang', 'Batam', 'Pekanbaru', 'Denpasar', 'Samarinda', 'Yogyakarta', 
    'Banjarmasin', 'Pontianak', 'Manado', 'Mataram', 'Balikpapan', 'Ambon', 'Jayapura', 'Kendari', 'Palangkaraya', 
    'Kupang', 'Palu', 'Ternate', 'Tarakan', 'Banda Aceh', 'Cirebon', 'Serang', 'Bengkulu', 'Gorontalo', 
    'Kediri', 'Salatiga', 'Magelang', 'Madiun', 'Pasuruan'
  ];

  List<String> _universities = [
    'Universitas Bumigora', 'Universitas Indonesia', 'Universitas Gadjah Mada', 'Universitas Airlangga', 'Universitas Diponegoro',
    'Universitas Sanata Dharma', 'Universitas Tarumanagara', 'Universitas Kristen Satya Wacana', 'Universitas Kristen Maranatha',
    'Universitas Mercu Buana', 'Universitas Ahmad Dahlan', 'Universitas Muhammadiyah Surakarta', 'Universitas Muhammadiyah Jakarta',
    'Universitas Muhammadiyah Sumatera Utara', 'Universitas Muhammadiyah Purwokerto', 'Universitas Muhammadiyah Palembang',
    'Universitas Muhammadiyah Kupang', 'Universitas Katolik Indonesia Atma Jaya', 'Universitas Ciputra', 'Universitas Presiden',
    'Universitas Islam Sultan Agung', 'Universitas Wijaya Kusuma Surabaya', 'Universitas Borobudur', 'Universitas Jayabaya',
    'Universitas Dr. Soetomo', 'Universitas Kuningan', 'Universitas Widya Mandala Surabaya', 'Universitas Muhammadiyah Tangerang',
    // Tambahkan universitas lainnya sesuai kebutuhan
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileFromFirebase();
  }

  Future<void> _loadProfileFromFirebase() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('account')
          .doc('profile')
          .get();

      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _selectedGender = doc['gender'] ?? 'Laki-Laki';
          _selectedCity = doc['location'] ?? 'Mataram';
          _emailController.text = doc['email'] ?? '';
          _aboutController.text = doc['about'] ?? '';
          _selectedUniversity = doc['university'] ?? 'Universitas Bumigora';
        });
      } else {
        setState(() {
        });
      }
    } catch (e) {
      setState(() {
      });
    }
  }


  Future<void> _saveToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('account').doc('profile').set({
        'name': _nameController.text,
        'gender': _selectedGender,
        'location': _selectedCity,
        'email': _emailController.text,
        'about': _aboutController.text,
        'university': _selectedUniversity,
        'saved_avatar': _getAvatarAssetPath(), // Simpan path avatar
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing; // Toggle mode edit
              });
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(_getAvatarAssetPath()),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception'); // Log jika ada kesalahan saat memuat gambar
                  },
                ),
              ),

              const SizedBox(height: 20),
              if (!_isEditing) ...[
                // Tampilkan data dalam mode non-edit
                ProfileSection(label: 'Name', value: _nameController.text),
                ProfileSection(label: 'Gender', value: _selectedGender),
                ProfileSection(label: 'City', value: _selectedCity),
                ProfileSection(label: 'Email', value: _emailController.text),
                ProfileSection(label: 'About', value: _aboutController.text),
                ProfileSection(label: 'University', value: _selectedUniversity),
              ] else ...[
                // Tampilkan kolom input dalam mode edit
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EditableSection(
                        title: 'Basic Information',
                        fields: [
                          EditableField(label: 'Name', controller: _nameController),
                          DropdownField(
                            label: 'Gender',
                            value: _selectedGender,
                            items: const ['Laki-Laki', 'Perempuan'],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!; // Perbarui pilihan gender
                              });
                            },
                          ),
                          DropdownField(
                            label: 'City',
                            value: _selectedCity,
                            items: _indonesiaCities,
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value!;
                              });
                            },
                          ),
                          EditableField(label: 'Email', controller: _emailController),
                          EditableField(label: 'About', controller: _aboutController),
                        ],
                      ),
                      EditableSection(
                        title: 'Education',
                        fields: [
                          DropdownField(
                            label: 'University',
                            value: _selectedUniversity,
                            items: _universities,
                            onChanged: (value) {
                              setState(() {
                                _selectedUniversity = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_isEditing) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false; // Batalkan edit
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveToFirebase().then((_) {
                            setState(() {
                              _isEditing = false; // Selesai edit
                            });
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                        color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String label;
  final String value;

  const ProfileSection({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}


class EditableSection extends StatelessWidget {
  final String title;
  final List<Widget> fields;

  const EditableSection({
    Key? key,
    required this.title,
    required this.fields,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              ...fields,
            ],
          ),
        ),
      ),
    );
  }
}

class EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EditableField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    Key? key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

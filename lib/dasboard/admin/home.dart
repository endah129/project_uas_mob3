import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/UI/logout.dart';
import 'package:mob3_login_022_endah/dasboard/admin/aktivitas.dart';
import 'package:mob3_login_022_endah/dasboard/admin/notif.dart';
import 'package:mob3_login_022_endah/dasboard/admin/transaksi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NotifikasiPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                // Navigasi ke LogoutPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
                // Tambahkan item menu lain jika diperlukan
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, Admin!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Here’s the latest update.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCardWithFirebase(
                  title: 'Users',
                  color: Colors.lightBlue,
                  icon: Icons.group,
                  collectionName: 'anggota',
                ),
                _buildStatCard(
                  title: 'Transactions',
                  value: '10',
                  color: Colors.green,
                  icon: Icons.attach_money,
                  onTap: () {
                    // navigasi ke halaman yang menampilkan transaksi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsScreen(),
                      ),
                    );
                  },
                ),
                _buildStatCard(
                  title: 'Reports',
                  value: '56',
                  color: Colors.redAccent,
                  icon: Icons.bar_chart,
                  onTap: () {
                    // navigasi ke laporan jika diperlukan
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Panggil Widget RecentActivityWidget
            const RecentActivityWidget(),

            const SizedBox(height: 20),

            // Quick Navigation
            const Text(
              'Quick Navigation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickNavCard(
                  title: 'Manage Users',
                  icon: Icons.group,
                  color: Colors.blueAccent,
                  onTap: () {
                    // Navigate to Manage Users
                  },
                ),
                _buildQuickNavCard(
                  title: 'View Reports',
                  icon: Icons.bar_chart,
                  color: Colors.green,
                  onTap: () {
                    // Navigate to Reports
                  },
                ),
                _buildQuickNavCard(
                  title: 'Payments',
                  icon: Icons.attach_money,
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to Payments
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardWithFirebase({
    required String title,
    required Color color,
    required IconData icon,
    required String collectionName,
  }) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingStatCard(title: title, color: color, icon: icon);
          }
          if (snapshot.hasError) {
            return _errorStatCard(title: title, color: color, icon: icon);
          }

          // Hitung jumlah dokumen
          final count = snapshot.data?.docs.length ?? 0;
          return _buildStatCard(
            title: title,
            value: count.toString(),
            color: color,
            icon: icon,
            onTap: () {}, // Menambahkan fungsi onTap kosong
          );
        },
      ),
    );
  }

  Widget _loadingStatCard({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return _buildStatCard(title: title, value: '...', color: color, icon: icon, onTap: () {});
  }

  Widget _errorStatCard({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return _buildStatCard(title: title, value: 'Error', color: color, icon: icon, onTap: () {});
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required VoidCallback onTap, // Perbaiki deklarasi onTap
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Gunakan onTap yang diteruskan
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNavCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // onTap harus menjadi fungsi tanpa parameter
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

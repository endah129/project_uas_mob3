import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/UI/logout.dart';

void main() {
  runApp(const MemberDashboardApp());
}

class MemberDashboardApp extends StatelessWidget {
  const MemberDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Member Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MemberDashboardScreen(),
    );
  }
}

class MemberDashboardScreen extends StatelessWidget {
  const MemberDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Dashboard'),
        backgroundColor: Colors.green.shade600,
      ),
      drawer: const MemberAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  DashboardCard(
                    icon: Icons.person,
                    title: 'Data Pribadi',
                  ),
                  DashboardCard(
                    icon: Icons.history,
                    title: 'Riwayat Transaksi',
                  ),
                  DashboardCard(
                    icon: Icons.settings,
                    title: 'Pengaturan Akun',
                  ),
                  DashboardCard(
                    icon: Icons.help,
                    title: 'Bantuan',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.green),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class MemberAppDrawer extends StatelessWidget {
  const MemberAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Pengguna Biasa'),
            accountEmail: const Text('online@user.com'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context), // Tetap di dashboard
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Data Pribadi'),
            onTap: () {
              // Implement navigation ke halaman Data Pribadi
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat Transaksi'),
            onTap: () {
              // Implement navigation ke halaman Riwayat Transaksi
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan Akun'),
            onTap: () {
              // Implement navigation ke halaman Pengaturan Akun
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Bantuan'),
            onTap: () {
              // Implement navigation ke halaman Bantuan
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogoutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

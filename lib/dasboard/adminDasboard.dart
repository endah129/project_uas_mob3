import 'package:flutter/material.dart';
import 'package:mob3_login_022_endah/dasboard/admin/help.dart';
import 'package:mob3_login_022_endah/dasboard/admin/home.dart';
import 'package:mob3_login_022_endah/dasboard/admin/report.dart';
import 'package:mob3_login_022_endah/dasboard/admin/account.dart';
import 'package:mob3_login_022_endah/data_anggota/dataAnggota.dart';
import 'package:mob3_login_022_endah/pembayaran/dataPembayaran.dart';
import 'package:mob3_login_022_endah/pinjaman/dataPinjaman.dart';

void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    ReportPage(),
    AccountPage(),
    HelpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.group, color: Colors.blue),
                    title: const Text('Anggota'),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DataAnggotaScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.monetization_on, color: Colors.green),
                    title: const Text('Pinjaman'),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DataPinjamanScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment, color: Colors.orange),
                    title: const Text('Angsuran'),
                    onTap: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataPembayaranScreen()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Menjamin ikon tidak bergerak
        selectedItemColor: Colors.blue, // Warna ikon yang dipilih
        unselectedItemColor: Colors.grey, // Warna ikon yang tidak dipilih
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}

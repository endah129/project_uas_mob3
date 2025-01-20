import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportPage(),
    );
  }
}

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double anggota = 0.0;
  double pinjaman = 0.0;
  double pembayaran = 0.0;

  @override
  void initState() {
    super.initState();
    getDataFromFirestore();
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> getDataFromFirestore() async {
    // Ambil data dari koleksi 'anggota', 'pinjaman', dan 'pembayaran'
    var anggotaSnapshot = await FirebaseFirestore.instance.collection('anggota').get();
    var pinjamanSnapshot = await FirebaseFirestore.instance.collection('pinjaman').get();
    var pembayaranSnapshot = await FirebaseFirestore.instance.collection('pembayaran').get();

    setState(() {
      // Hitung jumlah dari koleksi yang ada
      anggota = anggotaSnapshot.docs.length.toDouble();
      pinjaman = pinjamanSnapshot.docs.length.toDouble();
      pembayaran = pembayaranSnapshot.docs.length.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Tabs
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
              // Tab Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last Month',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'This Month',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Future',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Bar Chart Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Laporan Global',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: [
                            makeGroupData(0, 5, 7, 3),
                            makeGroupData(1, 6, 8, 4),
                            makeGroupData(2, 7, 6, 5),
                            makeGroupData(3, 8, 5, 7),
                            makeGroupData(4, 9, 12, 8),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  Widget text;
                                  switch (value.toInt()) {
                                    case 0:
                                      text = Text('Sep');
                                      break;
                                    case 1:
                                      text = Text('Okt');
                                      break;
                                    case 2:
                                      text = Text('Nov');
                                      break;
                                    case 3:
                                      text = Text('Des');
                                      break;
                                    case 4:
                                      text = Text('Jan');
                                      break;
                                    default:
                                      text = Text('');
                                  }
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: text,
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Pie Chart Section for Anggota, Pinjaman, Pembayaran
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Persentase',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Anggota ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Warna biru untuk Anggota
                            ),
                          ),
                          TextSpan(
                            text: 'Pinjaman ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red, // Warna merah untuk Pinjaman
                            ),
                          ),
                          TextSpan(
                            text: 'Pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green, // Warna hijau untuk Pembayaran
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // PieChart
                    Container(
                      width: 150,
                      height: 150,
                      child: anggota == 0.0 || pinjaman == 0.0 || pembayaran == 0.0
                          ? CircularProgressIndicator() // Loading indicator jika data belum ada
                          : PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: anggota,
                                    color: Colors.blue,
                                    title: '${(anggota / (anggota + pinjaman + pembayaran) * 100).toStringAsFixed(1)}%',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: pinjaman,
                                    color: Colors.red,
                                    title: '${(pinjaman / (anggota + pinjaman + pembayaran) * 100).toStringAsFixed(1)}%',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: pembayaran,
                                    color: Colors.green,
                                    title: '${(pembayaran / (anggota + pinjaman + pembayaran) * 100).toStringAsFixed(1)}%',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blue, // Anggota
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red, // Pinjaman
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: y3,
          color: Colors.green, // Pembayaran
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

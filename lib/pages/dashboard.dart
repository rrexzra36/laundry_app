import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/pages/buat_pesanan.dart';
import 'package:laundryapp/pages/input_layanan.dart';
import 'package:laundryapp/pages/input_pelanggan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../utils/constants.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Track active index
  int activeIndex = 0;
  int? _totalPendapatan;
  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Inisialisasi DatabaseHelper
  String fullName = ""; // Variabel untuk menyimpan fullName

  @override
  void initState() {
    super.initState();
    getFullNameFromPreferences(); // Ambil fullName saat widget diinisialisasi
    _calculatePendapatan();
  }

  Future<void> _calculatePendapatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    // Ambil total pendapatan dari database
    int total = await _databaseHelper.getTotalPendapatan(userId!.toInt());
    setState(() {
      _totalPendapatan = total;
    });
  }

  Future<void> getFullNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFullName = prefs.getString('fullName');
    if (storedFullName != null) {
      setState(() {
        fullName = storedFullName; // Perbarui nilai fullName
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0.0,
            top: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/washing_machine_illustration.png",
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Welcome Back,\n",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              TextSpan(
                                text: fullName.isNotEmpty
                                    ? fullName
                                    : "User", // Tampilkan fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/images/user.png",
                          height: 80,
                          width: 80,
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  color: Constants.scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 15.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Pendapatan Hari Ini",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      size: 25,
                                      color: Colors.greenAccent,
                                    ),
                                    const SizedBox(width: 5,),
                                    Text(
                                      _totalPendapatan == null
                                          ? 'Rp 0'
                                          : 'Rp ${NumberFormat("#,##0", "id_ID").format(_totalPendapatan)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const VerticalDivider(
                              color: Colors.white, // warna garis
                              thickness: 1, // ketebalan garis
                              indent: 20, // jarak atas dari Divider
                              endIndent: 20, // jarak bawah dari Divider
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 30,
                              ),
                              color: Colors.white,
                              onPressed: () {
                                _calculatePendapatan();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BuatPesanan()));
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Buat Pesanan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const InputPelanggan()));
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.group_add_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Pelanggan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const InputLayanan()));
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_laundry_service,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Layanan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

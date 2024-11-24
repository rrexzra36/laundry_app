import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/database/db_helper.dart';
import 'package:laundryapp/pages/rinican_pesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan extends StatefulWidget {
  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    searchController.addListener(_searchOrders);
  }

  void _fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId'); // Dapatkan userId
    List<Map<String, dynamic>> fetchedOrders =
        await DatabaseHelper().getAllPesanan(userId!.toInt());

    setState(() {
      orders = fetchedOrders;
      filteredOrders = orders;
    });
  }

  void _searchOrders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOrders = orders.where((order) {
        return order["namaPelanggan"]!.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Fungsi untuk menentukan warna background berdasarkan status
  Color _getColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey[100]!;
      case 1:
        return Colors.yellow[100]!;
      case 2:
        return Colors.blue[100]!;
      case 3:
        return Colors.green[100]!;
      default:
        return Colors.white;
    }
  }

// Fungsi untuk menentukan teks berdasarkan status
  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return "Diterima";
      case 1:
        return "Dikerjakan";
      case 2:
        return "Siap Diambil";
      case 3:
        return "Selesai";
      default:
        return "Unknown";
    }
  }

// Fungsi untuk menentukan warna teks berdasarkan status
  Color _getTextColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari nama pelanggan",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filteredOrders.isEmpty
                  ? const Center(
                      child: Text(
                        "Pesanan tidak ditemukan.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RincianPesanan(pesananId: order["pesananId"]),
                              ),
                            ).then((_) => _fetchOrders());
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order["namaPelanggan"] ?? "Kosong",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getColor(order["status"]),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          _getStatusText(order["status"]),
                                          style: TextStyle(
                                            color: _getTextColor(order["status"]),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("No. Nota"),
                                      Text(
                                        order["nota"] ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Total Harga"),
                                      Text(
                                        "Rp. ${NumberFormat("#,##0", "id_ID").format(order["totalPrice"])}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Tgl Pesanan"),
                                      Text(order["tanggalSelesai"] ?? "Kosong"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Estimasi Selesai"),
                                      Text(order["tanggalPesan"] ?? "Kosong"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

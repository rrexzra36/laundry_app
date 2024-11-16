import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pesanan extends StatefulWidget {
  const Pesanan({super.key});

  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  List<Map<String, String>> orders = [
    {
      "name": "Bima",
      "invoice": "INV-07112024-001",
      "totalPrice": "Rp 35.000",
      "orderDate": "07 Nov 2024 19:40",
      "estimatedCompletion": "10 Nov 2024 19:40",
      "status": "Selesai",
    },
    {
      "name": "Bima",
      "invoice": "INV-06112024-001",
      "totalPrice": "Rp 28.000",
      "orderDate": "06 Nov 2024 19:09",
      "estimatedCompletion": "09 Nov 2024 19:09",
      "status": "Selesai",
    },
    // Additional orders can be added here
  ];

  List<Map<String, String>> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredOrders = orders; // Display all orders initially
    searchController.addListener(_searchOrders);
  }

  void _searchOrders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOrders = orders.where((order) {
        return order["name"]!.toLowerCase().contains(query);
      }).toList();
    });
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
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('Pesanan')),
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
                  ? Center(
                child: Text(
                  "Pesanan tidak ditemukan.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order["name"] ?? "",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  order["status"] ?? "",
                                  style: const TextStyle(
                                      color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("No. Nota"),
                              Text(order["invoice"] ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Harga"),
                              Text(order["totalPrice"] ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Tgl Pesanan"),
                              Text(order["orderDate"] ?? ""),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Estimasi Selesai"),
                              Text(order["estimatedCompletion"] ?? ""),
                            ],
                          ),
                        ],
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

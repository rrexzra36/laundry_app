import 'package:flutter/material.dart';
import 'package:laundryapp/pages/dump/hitung_harga_layanan.dart';

import 'input_detail_layanan.dart';

class InputPesananLayanan extends StatefulWidget {
  @override
  State<InputPesananLayanan> createState() => _InputPesananLayananState();
}

class _InputPesananLayananState extends State<InputPesananLayanan> {
  List<Map<String, String>> layananList = [
    {
      "name": "Reguler",
      "price": "7000",
      "duration": "3",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    {
      "name": "Kilat",
      "price": "10000",
      "duration": "2",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    {
      "name": "Express",
      "price": "15000",
      "duration": "1",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    // Daftar pelanggan lainnya...
  ];

  List<Map<String, String>> filteredLayananList = [];

  TextEditingController searchController = TextEditingController();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double totalPrice = 0;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Mulai dengan menampilkan seluruh daftar pelanggan
    filteredLayananList = layananList;
  }

  // Fungsi untuk mencari pelanggan berdasarkan nama
  void searchPelanggan(String query) {
    setState(() {
      filteredLayananList = layananList
          .where((layanan) =>
          layanan["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

  }
  void _calculatePrice(Map<String, String> layanan) {
    setState(() {
      double weight = double.tryParse(_weightController.text) ?? 0;
      totalPrice = double.parse(layanan["price"]!) * weight; // Menggunakan harga yang dipilih
      isButtonEnabled = weight > 0;
    });
  }

  void showLayananModal(BuildContext context, Map<String, String> layanan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                      // Display selected service details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Layanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(layanan["name"]!, style: const TextStyle(fontSize: 14)), // Display name
                            ],
                          ),
                          Text(
                            "Rp. ${layanan["price"]!}/kg", // Display price
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Jenis layanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text(layanan["type"]!, style: const TextStyle(fontSize: 14)), // Display type
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Estimasi pengerjaan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Text("${layanan["duration"]} ${layanan["time"]}", style: const TextStyle(fontSize: 14)), // Display duration
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text("Deskripsi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(layanan["description"]!, style: const TextStyle(fontSize: 14)), // Display description
                      const SizedBox(height: 20),
                      const Center(
                        child: Text("Masukkan kuantitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Kuantitas",
                          prefixIcon: Icon(Icons.scale),
                          suffixText: "kg",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          helperText: "Gunakan tanda titik untuk menyatakan bilangan desimal. Misal: 7.5",
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _calculatePrice(layanan); // Panggil perhitungan harga saat kuantitas berubah
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _noteController,
                        maxLength: 150,
                        decoration: const InputDecoration(
                          labelText: "Catatan (jika ada)",
                          prefixIcon: Icon(Icons.note),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          helperText: "Contoh: Kemeja biru mudah luntur",
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                          Map<String, dynamic> selectedData = {
                            "layanan": layanan,
                            "totalPrice": totalPrice,
                            "weight": double.tryParse(_weightController.text) ?? 0
                          };
                          Navigator.pop(context, selectedData);
                          Navigator.pop(context, selectedData);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: isButtonEnabled ? Colors.blueAccent : Colors.grey,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: Text(
                          isButtonEnabled
                              ? 'PILIH LAYANAN - Rp ${totalPrice.toStringAsFixed(0)}'
                              : 'PILIH LAYANAN - Rp 0',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Layanan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // kembali ke halaman sebelumnya
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InputDetailLayanan()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar untuk mencari nama pelanggan
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  // Panggil fungsi search saat teks berubah
                  searchPelanggan(value);
                },
                decoration: InputDecoration(
                  hintText: "Cari nama layanan",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Jarak antara Search Bar dan ListTile

            // List pelanggan yang sudah difilter
            Expanded(
              child: ListView.builder(
                itemCount: filteredLayananList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.local_laundry_service_outlined,
                              size: 25, color: Colors.white),
                        ),
                        title: Text(filteredLayananList[index]["name"]!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rp. ${filteredLayananList[index]["price"]!}",
                              style: const TextStyle(fontSize: 12),
                            ), // Harga
                            Text(
                              "${filteredLayananList[index]["duration"]} ${filteredLayananList[index]["time"]}",
                              style: const TextStyle(fontSize: 12),
                            ), // Estimasi Pengerjaan
                          ],
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {
                            showLayananModal(context, filteredLayananList[index]);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                            side: const BorderSide(color: Colors.blueAccent),
                          ),
                          child: const Text("Pilih Layanan",
                              style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )
                    ],
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

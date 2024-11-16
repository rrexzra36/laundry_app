import 'package:flutter/material.dart';
import 'package:laundryapp/pages/detail_layanan.dart';

import 'detail_pelanggan.dart';
import 'input_detail_layanan.dart';

class InputLayanan extends StatefulWidget {
  @override
  State<InputLayanan> createState() => _InputLayananState();
}

class _InputLayananState extends State<InputLayanan> {
  List<Map<String, String>> layananList = [
    {
      "name": "Reguler",
      "price": "Rp. 7.000/kg",
      "duration": "3",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    {
      "name": "Kilat",
      "price": "Rp. 10.000/kg",
      "duration": "2",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    {
      "name": "Express",
      "price": "Rp. 15.000",
      "duration": "1",
      "type": "kiloan",
      "description": "Ini Deskripsi",
      "time": "Hari"
    },
    // Daftar pelanggan lainnya...
  ];

  List<Map<String, String>> filteredLayananList = [];

  TextEditingController searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Layanan"),
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
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLayanan(
                                  layanan: filteredLayananList[index]),
                            ),
                          );
                        },
                        child: ListTile(
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
                                filteredLayananList[index]["price"]!,
                                style: const TextStyle(fontSize: 12),
                              ), // Harga
                              Text(
                                "${filteredLayananList[index]["duration"]} ${filteredLayananList[index]["time"]}",
                                style: const TextStyle(fontSize: 12),
                              ), // Estimasi Pengerjaan
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
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

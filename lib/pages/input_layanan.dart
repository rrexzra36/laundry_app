import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/layanan_model.dart';
import 'detail_layanan.dart';
import 'input_detail_layanan.dart';

class InputLayanan extends StatefulWidget {
  const InputLayanan({super.key});

  @override
  State<InputLayanan> createState() => _InputLayananState();
}

class _InputLayananState extends State<InputLayanan> {
  List<Layanan> layananList = [];
  List<Layanan> filteredLayananList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLayanan();
  }

  Future<void> _loadLayanan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      final data = await DatabaseHelper().getAllLayanan(userId);
      setState(() {
        layananList = data;
        filteredLayananList = data;
      });
    }
  }

  void searchLayanan(String query) {
    setState(() {
      filteredLayananList = layananList
          .where((layanan) =>
          layanan.namaLayanan.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Map<String, dynamic> convertLayananToMap(Layanan layanan) {
    return {
      "id": layanan.id,
      "type": layanan.jenisLayanan,
      "name": layanan.namaLayanan,
      "price": layanan.harga,
      "duration": layanan.durasi,
      "time": layanan.satuanWaktu,
      "userId": layanan.userId,
    };
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputDetailLayanan(),
                ),
              ).then((_) => _loadLayanan());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: searchLayanan,
                decoration: InputDecoration(
                  hintText: "Cari nama layanan",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredLayananList.isEmpty
                  ? Center(
                child: Text(
                  "Belum ada data layanan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredLayananList.length,
                itemBuilder: (context, index) {
                  Layanan layanan = filteredLayananList[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> layananMap =
                          convertLayananToMap(layanan);
                          final updatedLayanan = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailLayanan(layanan: layananMap),
                            ),
                          );

                          if (updatedLayanan != null) {
                            setState(
                                  () {
                                    // Update layanan di daftar
                                final index = layananList.indexWhere(
                                        (layanan) =>
                                    layanan.id ==
                                        updatedLayanan['id']);
                                if (index != -1) {
                                  layananList[index] = Layanan(
                                    id: updatedLayanan['id'],
                                    jenisLayanan: updatedLayanan['type'],
                                    namaLayanan: updatedLayanan['name'],
                                    harga: updatedLayanan['price'],
                                    durasi: updatedLayanan['duration'],
                                    satuanWaktu: updatedLayanan['time'],
                                    userId: updatedLayanan['userId'],
                                  );
                                }
                                // Sinkronkan pencarian
                                searchLayanan(searchController.text);
                              },
                            );
                          }
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.local_laundry_service,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(layanan.namaLayanan),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Harga: Rp. ${layanan.harga}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Durasi: ${layanan.durasi} ${layanan.satuanWaktu}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
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
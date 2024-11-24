import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/pelanggan_model.dart';
import 'detail_pelanggan.dart';
import 'input_detail_pelanggan.dart';

class InputPelanggan extends StatefulWidget {
  const InputPelanggan({super.key});

  @override
  State<InputPelanggan> createState() => _InputPelangganState();
}

class _InputPelangganState extends State<InputPelanggan> {
  List<Pelanggan> pelangganList = [];
  List<Pelanggan> filteredPelangganList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPelanggan();
  }

  Future<void> _loadPelanggan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      final data = await DatabaseHelper().getAllPelanggan(userId);
      setState(() {
        pelangganList = data;
        filteredPelangganList = data;
      });
    }
  }

  void searchPelanggan(String query) {
    setState(() {
      filteredPelangganList = pelangganList
          .where((pelanggan) => pelanggan.namaPelanggan
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Map<String, dynamic> convertPelangganToMap(Pelanggan pelanggan) {
    return {
      "id": pelanggan.id,
      "name": pelanggan.namaPelanggan,
      "phone": pelanggan.nomorTelpon,
      "address": pelanggan.alamat,
      "userId": pelanggan.userId,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Pelanggan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputDetailPelanggan(),
                ),
              ).then((_) => _loadPelanggan());
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
                onChanged: searchPelanggan,
                decoration: InputDecoration(
                  hintText: "Cari nama pelanggan",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredPelangganList.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada data pelanggan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPelangganList.length,
                      itemBuilder: (context, index) {
                        Pelanggan pelanggan = filteredPelangganList[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Map<String, dynamic> pelangganMap =
                                    convertPelangganToMap(pelanggan);
                                final updatedPelanggan = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPelanggan(
                                        pelanggan: pelangganMap),
                                  ),
                                );

                                if (updatedPelanggan != null) {
                                  setState(() {
                                    // Update pelanggan di daftar
                                    final index = pelangganList.indexWhere(
                                        (pelanggan) =>
                                            pelanggan.id ==
                                            updatedPelanggan['id']);
                                    if (index != -1) {
                                      pelangganList[index] = Pelanggan(
                                        id: updatedPelanggan['id'],
                                        namaPelanggan: updatedPelanggan['name'],
                                        nomorTelpon: updatedPelanggan['phone'],
                                        alamat: updatedPelanggan['address'],
                                        userId: updatedPelanggan['userId'],
                                      );
                                    }
                                    // Sinkronkan pencarian
                                    searchPelanggan(searchController.text);
                                  });
                                }
                              },
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.person,
                                      size: 25, color: Colors.white),
                                ),
                                title: Text(pelanggan.namaPelanggan),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No. Telp: ${pelanggan.nomorTelpon}",
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "Alamat: ${pelanggan.alamat}",
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

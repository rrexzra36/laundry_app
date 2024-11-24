import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/pelanggan_model.dart';
import 'input_detail_pelanggan.dart';

class InputPesananPelanggan extends StatefulWidget {
  const InputPesananPelanggan({super.key});

  @override
  State<InputPesananPelanggan> createState() => _InputPesananPelangganState();
}

class _InputPesananPelangganState extends State<InputPesananPelanggan> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Pelanggan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  searchPelanggan(value);
                },
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
                      ListTile(
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
                        trailing: OutlinedButton(
                          onPressed: () {
                            final pelangganMap = {
                              'id' : pelanggan.id,
                              'namaPelanggan' : pelanggan.namaPelanggan,
                              'nomorTelepon':pelanggan.nomorTelpon,
                              'alamat' : pelanggan.alamat,
                              'userId' : pelanggan.userId,
                            };

                            print(pelanggan.id);
                            print(pelanggan.namaPelanggan);
                            print(pelanggan.nomorTelpon);
                            print(pelanggan.alamat);
                            print(pelanggan.userId);

                            Navigator.pop(context, pelangganMap);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text("Pilih Pelanggan",
                              style: TextStyle(color: Colors.white, fontSize: 12)),
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

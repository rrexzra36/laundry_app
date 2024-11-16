import 'package:flutter/material.dart';
import 'package:laundryapp/pages/input_detail_pelanggan.dart';
import 'detail_pelanggan.dart';

class InputPelanggan extends StatefulWidget {
  const InputPelanggan({super.key});

  @override
  State<InputPelanggan> createState() => _InputPelangganState();
}

class _InputPelangganState extends State<InputPelanggan> {
  List<Map<String, String>> pelangganList = [
    {"name": "John Doe", "phone": "0812345678", "address": "Jl. Merdeka No.1"},
    {
      "name": "Jane Smith",
      "phone": "0812345679",
      "address": "Jl. Kebon Jeruk No.2"
    },
    {
      "name": "Alice Johnson",
      "phone": "0812345680",
      "address": "Jl. Pahlawan No.3"
    },
    {
      "name": "Bob Brown",
      "phone": "0812345681",
      "address": "Jl. Sejahtera No.4"
    },
    // Daftar pelanggan lainnya...
  ];

  List<Map<String, String>> filteredPelangganList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPelangganList = pelangganList;
  }

  void searchPelanggan(String query) {
    setState(() {
      filteredPelangganList = pelangganList
          .where((pelanggan) =>
              pelanggan["name"]!.toLowerCase().contains(query.toLowerCase()))
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
              );
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
              child: ListView.builder(
                itemCount: filteredPelangganList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPelanggan(
                                  pelanggan: filteredPelangganList[index]),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person,
                                size: 25, color: Colors.white),
                          ),
                          title: Text(filteredPelangganList[index]["name"]!),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No. Telp: ${filteredPelangganList[index]["phone"]}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "Alamat: ${filteredPelangganList[index]["address"]}",
                                style: const TextStyle(fontSize: 12),
                              ),
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

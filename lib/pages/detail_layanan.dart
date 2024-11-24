import 'package:flutter/material.dart';
import 'package:laundryapp/pages/edit_layanan.dart';

class DetailLayanan extends StatefulWidget {
  final Map<String, dynamic> layanan;

  // Constructor dengan parameter required layanan
  const DetailLayanan({Key? key, required this.layanan}) : super(key: key);

  @override
  State<DetailLayanan> createState() => _DetailLayananState();
}

class _DetailLayananState extends State<DetailLayanan> {
  late Map<String, dynamic> layanan;

  @override
  void initState() {
    super.initState();
    layanan = widget.layanan; // Salin data pelanggan dari parameter awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Layanan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print("Updated pelanggan before pop: $layanan");
            Navigator.pop(context, layanan);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigasi ke halaman edit dan tunggu hasilnya
              final updatedLayanan = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditLayanan(layanan: layanan),
                ),
              );

              // Jika ada data yang dikembalikan, perbarui state
              if (updatedLayanan != null) {
                setState(() {
                  layanan = updatedLayanan;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.local_laundry_service,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    layanan["name"] ?? "Nama Tidak Tersedia",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Harga\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Rp. ${layanan["price"] ?? 'Tidak Ada Harga'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Estimasi Pengerjaan\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${layanan["duration"] ?? ''} ${layanan["time"] ?? 'Tidak Ada Estimasi Durasi'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Deskripsi\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${layanan["description"] ?? 'Tidak Ada Deskripsi'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

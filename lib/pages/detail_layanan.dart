import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundryapp/pages/edit_layanan.dart';

class DetailLayanan extends StatelessWidget {
  final Map<String, dynamic> layanan;

  DetailLayanan({required this.layanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Layanan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditLayanan(layanan : layanan),
                ),
              );
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
                    radius: 50, // Ukuran avatar
                    backgroundColor: Colors.grey, // Warna latar belakang
                    child: Icon(
                      Icons.local_laundry_service,
                      size: 50, // Ukuran ikon
                      color: Colors.white, // Warna ikon
                    ),
                  ),
                  const SizedBox(height: 10), // Jarak antara avatar dan nama

                  Text(
                    layanan["name"] ?? "Nama Tidak Tersedia",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Jarak antara nama dan informasi lainnya

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Harga\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${layanan["price"] ?? 'Tidak Ada Harga'}",
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
                    text: layanan["description"] ?? 'Tidak Ada Deskripsi',
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laundryapp/pages/edit_pelanggan.dart';

class DetailPelanggan extends StatelessWidget {
  final Map<String, dynamic> pelanggan;

  // Constructor dengan parameter required pelanggan
  DetailPelanggan({required this.pelanggan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pelanggan"),
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
                  builder: (context) => EditPelanggan(pelanggan : pelanggan),
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
            // Menampilkan avatar pelanggan
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50, // Menyesuaikan ukuran avatar
                    backgroundColor:
                        Colors.grey, // Memberikan warna latar belakang
                    child: Icon(
                      Icons.person,
                      size: 50, // Ukuran ikon
                      color: Colors.white, // Warna ikon
                    ),
                  ),
                  const SizedBox(height: 10), // Jarak antara avatar dan nama
                  Text(
                    pelanggan["name"] ??
                        "Nama Tidak Tersedia", // Menampilkan nama pelanggan
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
                    text: "Telepon\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${pelanggan["phone"] ?? 'Tidak Ada No. Telp'}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
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
                    text: "Alamat\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "${pelanggan["address"] ?? 'Tidak Ada Alamat'}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
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

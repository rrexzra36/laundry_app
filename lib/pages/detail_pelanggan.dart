import 'package:flutter/material.dart';
import 'package:laundryapp/pages/edit_pelanggan.dart';

class DetailPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  // Constructor dengan parameter required pelanggan
  const DetailPelanggan({Key? key, required this.pelanggan}) : super(key: key);

  @override
  State<DetailPelanggan> createState() => _DetailPelangganState();
}

class _DetailPelangganState extends State<DetailPelanggan> {
  late Map<String, dynamic> pelanggan;

  @override
  void initState() {
    super.initState();
    pelanggan = widget.pelanggan; // Salin data pelanggan dari parameter awal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pelanggan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print("Updated pelanggan before pop: $pelanggan");
            Navigator.pop(context, pelanggan);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // Navigasi ke halaman edit dan tunggu hasilnya
              final updatedPelanggan = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPelanggan(pelanggan: pelanggan),
                ),
              );

              // Jika ada data yang dikembalikan, perbarui state
              if (updatedPelanggan != null) {
                setState(() {
                  pelanggan = updatedPelanggan;
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
                    pelanggan["name"] ?? "Nama Tidak Tersedia",
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

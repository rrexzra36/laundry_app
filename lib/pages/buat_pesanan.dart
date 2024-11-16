import 'package:flutter/material.dart';
import 'package:laundryapp/pages/konfirmasi_pesanan.dart';
import 'package:laundryapp/pages/pilih_pesanan_layanan.dart';

import 'pilih_pesanan_pelanggan.dart';

class BuatPesanan extends StatefulWidget {
  @override
  State<BuatPesanan> createState() => _BuatPesananState();
}

class _BuatPesananState extends State<BuatPesanan> {
  Map<String, String>? selectedPelanggan;
  Map<String, dynamic>? selectedLayanan;

  double totalPrice = 0;
  double weight = 0;

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = selectedPelanggan != null &&
        selectedLayanan != null &&
        totalPrice != 0 &&
        weight != 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Pesanan"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pelanggan Section
          Container(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pelanggan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Silahkan pilih pelanggan",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final pelanggan =
                            await Navigator.push<Map<String, String>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputPesananPelanggan(),
                          ),
                        );

                        if (pelanggan != null) {
                          setState(() {
                            selectedPelanggan = pelanggan;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text("Pilih Pelanggan",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                if (selectedPelanggan != null) ...[
                  Card(
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          child:
                              Icon(Icons.person, size: 25, color: Colors.white),
                        ),
                        title: Text(selectedPelanggan!["name"]!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedPelanggan!["phone"]!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              selectedPelanggan!["address"]!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Layanan Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Layanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Silahkan pilih layanan",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final selectedData =
                            await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputPesananLayanan(),
                          ),
                        );

                        if (selectedData != null) {
                          setState(() {
                            selectedLayanan = selectedData;
                            totalPrice = selectedData['totalPrice'] ?? 0;
                            weight = selectedData['weight'] ?? 0;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text("Pilih Layanan",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                if (selectedLayanan != null) ...[
                  Card(
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nama layanan',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    selectedLayanan!['layanan']['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Harga',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Rp. ${selectedLayanan!['layanan']['price']}/kg',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jenis layanan',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    selectedLayanan!['layanan']['type'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Estimasi pengerjaan',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '${selectedLayanan!['layanan']['duration']} ${selectedLayanan!['layanan']['time']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey[300],
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Kuantitas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                '${weight.toInt()} kg',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey[300], height: 20),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Rp. ${selectedLayanan!['totalPrice'].toInt()}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),

          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Rp. ${selectedLayanan?['totalPrice']?.toInt() ?? 0}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      backgroundColor: isButtonEnabled
                          ? Colors.blue
                          : Colors.grey, // Warna tombol grey jika tidak aktif
                    ),
                    onPressed: isButtonEnabled
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KonfirmasiPesanan(
                                    // selectedPelanggan: selectedPelanggan!,
                                    // selectedLayanan: selectedLayanan!,
                                    // totalPrice: totalPrice,
                                    // weight: weight,
                                    ),
                              ),
                            );
                          }
                        : null, // Tidak aktifkan tombol jika tidak memenuhi kondisi
                    child: const Text(
                      'LANJUTKAN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

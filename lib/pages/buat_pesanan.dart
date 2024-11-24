import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/pages/konfirmasi_pesanan.dart';
import 'package:laundryapp/pages/pilih_pesanan_layanan.dart';
import 'pilih_pesanan_pelanggan.dart';

class BuatPesanan extends StatefulWidget {
  @override
  State<BuatPesanan> createState() => _BuatPesananState();
}

class _BuatPesananState extends State<BuatPesanan> {
  Map<String, dynamic>? selectedPelanggan;
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pelanggan Section
          _buildPelangganSection(),

          // Layanan Section
          _buildLayananSection(),

          const Spacer(),

          // Footer with total price and button
          _buildFooter(isButtonEnabled),
        ],
      ),
    );
  }

  Widget _buildPelangganSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
              const Text(
                "Silahkan pilih pelanggan",
                style: TextStyle(color: Colors.grey),
              ),
              OutlinedButton(
                onPressed: () async {
                  final pelanggan = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputPesananPelanggan(),
                    ),
                  );
                  if (pelanggan != null) {
                    print('Received pelanggan data: $pelanggan');
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
          if (selectedPelanggan != null) _buildPelangganCard(),
        ],
      ),
    );
  }

  Widget _buildPelangganCard() {
    return Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 25, color: Colors.white),
            ),
            title: Text(selectedPelanggan!["namaPelanggan"]! ??
                'Nama tidak tersedia'), // Safe access with default value
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  selectedPelanggan!["nomorTelepon"]! ??
                      'Nomor telepon tidak tersedia',
                  style: const TextStyle(fontSize: 12),
                ), // Safe access with default value
                Text(
                  selectedPelanggan!["alamat"]! ?? 'Alamat tidak tersedia',
                  style: const TextStyle(fontSize: 12),
                ), // Safe access with default value
              ],
            ),
          ),
        ));
  }

  Widget _buildLayananSection() {
    return Container(
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
              const Text(
                "Silahkan pilih layanan",
                style: TextStyle(color: Colors.grey),
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
          if (selectedLayanan != null) _buildLayananCard(),
        ],
      ),
    );
  }

  Widget _buildLayananCard() {
    return Card(
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
                          fontWeight: FontWeight.bold, fontSize: 14),
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
                      'Rp. ${NumberFormat("#,##0", "id_ID").format(selectedLayanan!['layanan']['price'])}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
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
                          fontWeight: FontWeight.bold, fontSize: 14),
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
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Divider(
              color: Colors.grey[300],
              height: 20,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kuantitas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '${weight.toInt()} kg',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 20,
              thickness: 2,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp. ${NumberFormat("#,##0", "id_ID").format(selectedLayanan!['totalPrice'].toInt())}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool isButtonEnabled) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text('Total',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(width: 10),
            Text(
              'Rp. ${NumberFormat("#,##0", "id_ID").format(totalPrice.toInt())}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
                backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
              ),
              onPressed: isButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KonfirmasiPesanan(
                            // Pass selected data here
                            pelanggan: selectedPelanggan!,
                            layanan: selectedLayanan!,
                            totalPrice: totalPrice,
                            weight: weight,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                "LANJUTKAN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/layanan_model.dart';
import 'input_detail_layanan.dart';

class InputPesananLayanan extends StatefulWidget {
  @override
  State<InputPesananLayanan> createState() => _InputPesananLayananState();
}

class _InputPesananLayananState extends State<InputPesananLayanan> {
  List<Layanan> layananList = [];
  List<Layanan> filteredLayananList = [];
  TextEditingController searchController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  double totalPrice = 0;
  bool isButtonEnabled = false;

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

  void _calculatePrice(layananMap) {
    setState(() {
      double weight = double.tryParse(_weightController.text) ?? 0;
      totalPrice = layananMap["price"] * weight;
      isButtonEnabled = weight > 0;
    });
  }

  void showLayananModal(BuildContext context, Map<String, dynamic> layananMap) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      // Display selected service details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Layanan",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(layananMap["name"]!,
                                  style: const TextStyle(
                                      fontSize: 14)), // Display name
                            ],
                          ),
                          Text(
                            "Rp. ${NumberFormat("#,##0", "id_ID").format(layananMap["price"]!)}/kg",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Jenis layanan",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(layananMap["type"]!,
                                  style: const TextStyle(
                                      fontSize: 14)), // Display type
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Estimasi pengerjaan",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                  "${layananMap["duration"]} ${layananMap["time"]}",
                                  style: const TextStyle(
                                      fontSize: 14)), // Display duration
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text("Deskripsi",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(layananMap["description"] ?? "Tidak ada deskripsi",
                          style: const TextStyle(
                              fontSize:
                                  14)), // Display description or default message
                      const SizedBox(height: 20),
                      const Center(
                        child: Text("Masukkan kuantitas",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: "Kuantitas",
                          prefixIcon: Icon(Icons.scale),
                          suffixText: "kg",
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          helperText:
                              "Gunakan tanda titik untuk menyatakan bilangan desimal. Misal: 7.5",
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _calculatePrice(
                              layananMap); // Panggil perhitungan harga saat kuantitas berubah
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _noteController,
                        maxLength: 150,
                        decoration: const InputDecoration(
                          labelText: "Catatan (jika ada)",
                          prefixIcon: Icon(Icons.note),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          helperText: "Contoh: Kemeja biru mudah luntur",
                          helperMaxLines: 2,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                Map<String, dynamic> selectedData = {
                                  "layanan": layananMap,
                                  "totalPrice": totalPrice,
                                  "weight":
                                      double.tryParse(_weightController.text) ??
                                          0
                                };
                                Navigator.pop(context, selectedData);
                                print(selectedData);
                                Navigator.pop(context, selectedData);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              isButtonEnabled ? Colors.blue : Colors.grey,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: Text(
                          isButtonEnabled
                              ? 'PILIH LAYANAN - Rp ${NumberFormat("#,##0", "id_ID").format(totalPrice)}'
                              : 'PILIH LAYANAN - Rp 0',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Layanan"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InputDetailLayanan()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                          ListTile(
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.local_laundry_service_outlined,
                                  size: 25, color: Colors.white),
                            ),
                            title: Text(layanan.namaLayanan),
                            subtitle: Text(
                                "Rp. ${NumberFormat("#,##0", "id_ID").format(layanan.harga)}\n${layanan.durasi} ${layanan.satuanWaktu}"),
                            trailing: OutlinedButton(
                              onPressed: () {
                                final layananMap = convertLayananToMap(
                                    layanan); // Konversi ke Map
                                showLayananModal(
                                    context, layananMap); // Kirim Map ke modal
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                side:
                                    const BorderSide(color: Colors.blue),
                              ),
                              child: const Text("Pilih Layanan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
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
    );
  }
}

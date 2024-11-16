import 'package:flutter/material.dart';

class HitungHarga extends StatefulWidget {
  final Map<String, String> layananList; // Accept selected service details

  HitungHarga({required this.layananList});

  @override
  _HitungHargaState createState() => _HitungHargaState();
}

class _HitungHargaState extends State<HitungHarga> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late final Map<String, String> layanan; // Declare the layanan variable
  double totalPrice = 0;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    layanan = widget.layananList; // Initialize layanan with passed data
  }

  void _calculatePrice() {
    setState(() {
      double weight = double.tryParse(_weightController.text) ?? 0;
      totalPrice = double.parse(layanan["price"]!) * weight; // Use the passed price
      isButtonEnabled = weight > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Service'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display selected service details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Layanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(layanan["name"]!, style: const TextStyle(fontSize: 14)), // Display name
                        ],
                      ),
                      Text(
                        "Rp. ${layanan["price"]!}/kg", // Display price
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          const Text("Jenis layanan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(layanan["type"]!, style: const TextStyle(fontSize: 14)), // Display type
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Estimasi pengerjaan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text("${layanan["duration"]} ${layanan["time"]}", style: const TextStyle(fontSize: 14)), // Display duration
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("Deskripsi", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(layanan["description"]!, style: const TextStyle(fontSize: 14)), // Display description
                  const SizedBox(height: 20),
                  const Center(
                    child: Text("Masukkan kuantitas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Kuantitas",
                      prefixIcon: Icon(Icons.scale),
                      suffixText: "kg",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      helperText: "Gunakan tanda titik untuk menyatakan bilangan desimal. Misal: 7.5",
                      helperMaxLines: 2,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _calculatePrice();
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
                        ? () {}
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: isButtonEnabled ? Colors.blueAccent : Colors.grey,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(
                      isButtonEnabled
                          ? 'PILIH LAYANAN - Rp ${totalPrice.toStringAsFixed(0)}'
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
  }
}

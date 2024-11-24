import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../models/layanan_model.dart';

class InputDetailLayanan extends StatefulWidget {
  @override
  _InputDetailLayananState createState() => _InputDetailLayananState();
}

class _InputDetailLayananState extends State<InputDetailLayanan> {
  TextEditingController namaLayananController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController durasiController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  String? jenisLayanan; // Dropdown untuk jenis layanan
  String? satuanWaktu; // Dropdown untuk satuan waktu (misal menit, jam)

  @override
  void dispose() {
    namaLayananController.dispose();
    hargaController.dispose();
    durasiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Input Detail Layanan'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown untuk Jenis Layanan
              DropdownButtonFormField<String>(
                value: jenisLayanan,
                items: ['Kiloan', 'Satuan', 'Paket']
                    .map((jenis) => DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  jenisLayanan = value;
                }),
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.local_laundry_service_sharp),
                  labelText: "Jenis Layanan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Contoh: Reguler, Cuci Kering, Setrika, dll.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Nama Layanan
              TextField(
                controller: namaLayananController,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.drive_file_rename_outline_outlined),
                  labelText: "Nama Layanan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Harga
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandSeparatorFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  prefixText: 'Rp. ',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.money),
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Durasi
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: durasiController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.lock_clock),
                        labelText: "Durasi",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: satuanWaktu,
                      items: ['Hari', 'Jam']
                          .map((satuan) => DropdownMenuItem(
                        value: satuan,
                        child: Text(satuan),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() {
                        satuanWaktu = value;
                      }),
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Satuan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Estimasi selesai dapat diubah saat membuat pesanan",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Deskripsi
              TextField(
                controller: deskripsiController,
                maxLength: 200,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.description),
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                  counterText: '', // Menyembunyikan counter
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text(
                      "Contoh: Hanya setrika saja",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Text(
                    '${deskripsiController.text.length}/100',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Tombol untuk menyimpan data Layanan
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    String jenis = jenisLayanan ?? '';
                    String namaLayanan = namaLayananController.text.trim();
                    String harga =
                    hargaController.text.replaceAll('.', '').trim();
                    String durasi = durasiController.text.trim();
                    String satuan = satuanWaktu ?? '';
                    String deskripsi = deskripsiController.text.trim();

                    print("Jenis : $jenis");
                    print("Nama Layanan : $namaLayanan");
                    print("Harga : $harga");
                    print("Durasi : $durasi");
                    print("Satuan : $satuan");
                    print("Deskripsi : $deskripsi");

                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('userId');

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "User tidak ditemukan. Silakan login kembali.")),
                      );
                      return;
                    }

                    if (jenis.isNotEmpty &&
                        namaLayanan.isNotEmpty &&
                        harga.isNotEmpty &&
                        durasi.isNotEmpty &&
                        satuan.isNotEmpty) {
                      Layanan layanan = Layanan(
                        jenisLayanan: jenis,
                        namaLayanan: namaLayanan,
                        harga: int.parse(harga),
                        durasi: int.parse(durasi),
                        satuanWaktu: satuan,
                        deskripsi: deskripsi,
                        userId: userId,
                      );

                      try {
                        await DatabaseHelper().tambahLayanan(layanan);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Data Layanan berhasil disimpan!")),
                        );

                        // Reset form
                        setState(() {
                          jenisLayanan = null;
                          satuanWaktu = null;
                          namaLayananController.clear();
                          hargaController.clear();
                          durasiController.clear();
                          deskripsiController.clear();
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menyimpan data: $e")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Mohon lengkapi semua data")),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 5),
                      Text("Simpan Layanan")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text.replaceAll('.', ''); // Hapus titik lama
    String formattedText = _formatNumberWithDots(newText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatNumberWithDots(String number) {
    if (number.isEmpty) return '';
    StringBuffer buffer = StringBuffer();
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(number[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join('');
  }
}

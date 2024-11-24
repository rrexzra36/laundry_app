import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundryapp/models/layanan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';

class EditLayanan extends StatefulWidget {
  final Map<String, dynamic> layanan;

  EditLayanan({required this.layanan});

  @override
  _EditLayananState createState() => _EditLayananState();
}

class _EditLayananState extends State<EditLayanan> {
  late String? jenisLayanan;
  late String? satuanWaktu;
  late TextEditingController namaLayananController;
  late TextEditingController hargaController;
  late TextEditingController durasiController;
  late TextEditingController deskripsiController;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    jenisLayanan = widget.layanan['type'];
    satuanWaktu = widget.layanan['time'];
    namaLayananController = TextEditingController(text: widget.layanan['name']);
    hargaController = TextEditingController(text: widget.layanan['price'].toString());
    durasiController = TextEditingController(text: widget.layanan['duration'].toString());
    deskripsiController = TextEditingController(text: widget.layanan['description']);
  }

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
        title: const Text('Edit Layanan'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Jenis Layanan",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.local_laundry_service_sharp),
                  border: OutlineInputBorder(),
                ),
                value: jenisLayanan,  // Nilai yang dipilih
                items: ['Kiloan', 'Satuan', 'Paket']
                    .map((jenis) => DropdownMenuItem(
                  value: jenis,
                  child: Text(jenis),
                ))
                    .toList(),
                onChanged: (value) {
                  print("Selected value: $value");
                  setState(() {
                    jenisLayanan = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: namaLayananController,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.drive_file_rename_outline_outlined),
                  labelText: "Nama Layanan",
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

              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandSeparatorFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixText: 'Rp. ',
                  suffixText: '/kg',
                  prefixIcon: Icon(Icons.money),
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: durasiController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIcon: Icon(Icons.lock_clock),
                        labelText: "Durasi Pengerjaan",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Satuan Waktu",
                        border: OutlineInputBorder(),
                      ),
                      value: satuanWaktu,
                      items: ['Hari', 'Jam']
                          .map((satuan) => DropdownMenuItem(
                        value: satuan,
                        child: Text(satuan),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          satuanWaktu = value;
                        });
                      },
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: deskripsiController,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: Icon(Icons.sticky_note_2),
                      labelText: "Deskripsi",
                      border: OutlineInputBorder(),
                      counterText: '',
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
                ],
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('userId'); // Get the userId from shared preferences

                    String editType = jenisLayanan.toString();
                    String editName = namaLayananController.text;
                    int editPrice = int.tryParse(hargaController.text.replaceAll('.', '').trim()) ?? 0;
                    int editDuration = int.tryParse(durasiController.text) ?? 0;
                    String editTime = satuanWaktu ?? '';
                    String editDescription = deskripsiController.text;

                    // Ensure all fields are filled before proceeding
                    if (editType.isNotEmpty &&
                        editName.isNotEmpty &&
                        editPrice > 0 &&
                        editDuration > 0 &&
                        editTime.isNotEmpty) {
                      try {
                        final updatedLayanan = Layanan(
                          id: widget.layanan['id'],
                          jenisLayanan: editType,
                          namaLayanan: editName,
                          harga: editPrice,
                          durasi: editDuration,
                          satuanWaktu: editTime,
                          deskripsi: editDescription,
                          userId: userId!.toInt(), // Ensure userId is not null
                        );
                        // Call the database helper to update the Layanan record
                        await _dbHelper.updateLayanan(updatedLayanan);

                        final updatedLayananFix = {
                          'id': widget.layanan['id'],
                          'type': jenisLayanan,
                          'name': namaLayananController.text,
                          'price': int.tryParse(hargaController.text.replaceAll('.', '')) ?? 0,
                          'duration': int.tryParse(durasiController.text),
                          'time': satuanWaktu,
                          'description': deskripsiController.text,
                          'userId': userId!.toInt(),
                        };

                        print(widget.layanan['id']);
                        print(jenisLayanan);
                        print(namaLayananController.text);
                        print(hargaController.text);
                        print(durasiController.text);
                        print(satuanWaktu);
                        print(deskripsiController.text);

                        Navigator.pop(context, updatedLayananFix);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: const Text("Data Layanan berhasil diperbarui!"),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } catch (e) {
                        // Catch errors and show error message
                        print("ID: ${widget.layanan['id']}, UserID: ${widget.layanan['userId']}");
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Gagal memperbarui data: $e"),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } else {
                      // Show message if required fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Mohon lengkapi semua data"),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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
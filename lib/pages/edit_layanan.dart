import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    jenisLayanan = widget.layanan['type'];
    print(jenisLayanan);
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
          onPressed: () => Navigator.pop(context),
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
                items: const [
                  DropdownMenuItem(value: "kiloan", child: Text("Kiloan")),
                  DropdownMenuItem(value: "satuan", child: Text("Satuan")),
                  DropdownMenuItem(value: "paket", child: Text("Paket")),
                ],
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
                  _ThousandsSeparatorFormatter(),
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
                      items: const [
                        DropdownMenuItem(value: "Hari", child: Text("Hari")),
                        DropdownMenuItem(value: "Jam", child: Text("Jam")),
                      ],
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
                  onPressed: () {
                    String jenis = jenisLayanan ?? '';
                    String namaLayanan = namaLayananController.text;
                    String harga = hargaController.text;
                    String durasi = durasiController.text;
                    String satuan = satuanWaktu ?? '';
                    String deskripsi = deskripsiController.text;

                    if (jenis.isNotEmpty &&
                        namaLayanan.isNotEmpty &&
                        harga.isNotEmpty &&
                        durasi.isNotEmpty &&
                        satuan.isNotEmpty &&
                        deskripsi.isNotEmpty) {
                      Navigator.pop(context, {
                        'type': jenis,
                        'name': namaLayanan,
                        'price': harga,
                        'duration': durasi,
                        'time': satuan,
                        'description': deskripsi,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: const Text("Data layanan berhasil diperbarui!"),
                          behavior: SnackBarBehavior.floating, // Membuat snackbar melayang
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Margin untuk posisi
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    } else {
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

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
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

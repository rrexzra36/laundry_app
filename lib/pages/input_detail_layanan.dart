import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputDetailLayanan extends StatefulWidget {
  @override
  _InputDetailLayananState createState() => _InputDetailLayananState();
}

class _InputDetailLayananState extends State<InputDetailLayanan> {
  // Variabel untuk menampung nilai dropdown dan input field
  String? jenisLayanan;
  String? satuanWaktu;
  TextEditingController namaLayananController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController durasiController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan controller saat widget dihancurkan
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
              // Dropdown untuk memilih jenis layanan
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Jenis Layanan",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.local_laundry_service_sharp),
                  border: OutlineInputBorder(),
                ),
                value: jenisLayanan,
                items: const [
                  DropdownMenuItem(value: "kiloan", child: Text("Kiloan")),
                  DropdownMenuItem(value: "satuan", child: Text("Satuan")),
                  DropdownMenuItem(value: "paket", child: Text("Paket")),
                ],
                onChanged: (value) {
                  setState(() {
                    jenisLayanan = value;
                  });
                },
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
              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text("Contoh: Reguler, Cuci Kering, Setrika, dll.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Harga
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorFormatter(),
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

              // Row yang berisi TextField untuk Durasi dan Dropdown untuk Satuan Waktu
              Row(
                children: [
                  // TextField untuk Durasi Pengerjaan
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

                  // Dropdown untuk Satuan Waktu
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
                child: const Text("Estimasi selsai dapat diubah saat membuat pesanan",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Deskripsi dengan batas maksimal 100 karakter
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
                      counterText: '', // Menyembunyikan counter bawaan
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Row untuk teks tambahan dan counter karakter
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


              // Tombol untuk menyimpan layanan
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    // Fungsi untuk menyimpan layanan
                    // Misalnya, Anda dapat mengambil data dari controller dan menambahkan logika penyimpanan di sini
                    String jenis = jenisLayanan ?? '';
                    String namaLayanan = namaLayananController.text;
                    String harga = hargaController.text;
                    String durasi = durasiController.text;
                    String satuan = satuanWaktu ?? '';
                    String deskripsi = deskripsiController.text;

                    // Menampilkan pesan atau melakukan sesuatu dengan data yang dimasukkan
                    if (jenis.isNotEmpty &&
                        namaLayanan.isNotEmpty &&
                        harga.isNotEmpty &&
                        durasi.isNotEmpty &&
                        satuan.isNotEmpty) {
                      // Implementasikan penyimpanan layanan di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Layanan berhasil disimpan!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Mohon lengkapi semua data")),
                      );
                    }
                  },
                  child: const Text("Simpan Layanan"),
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
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Hapus karakter non-angka
    String formattedText = _formatNumberWithDots(newText); // Format dengan titik

    // Menambahkan kembali "Rp." di depan
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatNumberWithDots(String number) {
    // Format angka dengan pemisah titik setiap 3 digit
    if (number.isEmpty) return '';

    StringBuffer buffer = StringBuffer();
    int count = 0;

    for (int i = number.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        buffer.write('.'); // Menambahkan titik sebagai pemisah
      }
      buffer.write(number[i]);
      count++;
    }

    // Balik urutan string karena kita memulai dari belakang
    return buffer.toString().split('').reversed.join('');
  }
}
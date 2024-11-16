import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  // Constructor dengan parameter required pelanggan
  EditPelanggan({required this.pelanggan});

  @override
  _EditPelangganState createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  late TextEditingController editNamaPelangganController;
  late TextEditingController editNomorTelponController;
  late TextEditingController editAlamatController;

  @override
  void initState() {
    super.initState();
    // Menyimpan data awal pelanggan di controller
    editNamaPelangganController =
        TextEditingController(text: widget.pelanggan['name']);
    editNomorTelponController =
        TextEditingController(text: widget.pelanggan['phone']);
    editAlamatController =
        TextEditingController(text: widget.pelanggan['address']);
  }

  @override
  void dispose() {
    // Membersihkan controller saat widget dihancurkan
    editNamaPelangganController.dispose();
    editNomorTelponController.dispose();
    editAlamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Ubah Data Pelanggan'),
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
              // TextField untuk Nama Pelanggan
              TextField(
                controller: editNamaPelangganController,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  labelText: "Nama Pelanggan",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Nomor Telepon
              TextField(
                controller: editNomorTelponController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Nomor Telpon",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Digunakan untuk kirim nota via WhatsApp",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Alamat
              TextField(
                controller: editAlamatController,
                maxLength: 200,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.location_on_outlined),
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                  counterText: '', // Menyembunyikan counter bawaan
                ),
              ),
              const SizedBox(height: 25),

              // Tombol untuk menyimpan data Pelanggan
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    // Mengambil data dari controller
                    String editNamaPelanggan = editNamaPelangganController.text;
                    String editNomorTelpon = editNomorTelponController.text;
                    String editAlamat = editAlamatController.text;

                    // Validasi data
                    if (editNamaPelanggan.isNotEmpty &&
                        editNomorTelpon.isNotEmpty &&
                        editAlamat.isNotEmpty) {
                      // Mengirim data yang diperbarui kembali ke halaman sebelumnya
                      Navigator.pop(context, {
                        'name': editNamaPelanggan,
                        'phone': editNomorTelpon,
                        'address': editAlamat,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: const Text("Data Pelanggan berhasil diperbarui!"),
                          behavior: SnackBarBehavior.floating, // Membuat snackbar melayang
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Margin untuk posisi
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), // Menambahkan sudut melengkung
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
                      Text("Simpan Pelanggan")
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

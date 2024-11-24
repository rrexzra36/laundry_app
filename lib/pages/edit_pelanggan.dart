import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundryapp/models/pelanggan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';

class EditPelanggan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  EditPelanggan({required this.pelanggan});

  @override
  _EditPelangganState createState() => _EditPelangganState();
}

class _EditPelangganState extends State<EditPelanggan> {
  late TextEditingController editNamaPelangganController;
  late TextEditingController editNomorTelponController;
  late TextEditingController editAlamatController;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    editNamaPelangganController =
        TextEditingController(text: widget.pelanggan['name']);
    editNomorTelponController =
        TextEditingController(text: widget.pelanggan['phone']);
    editAlamatController =
        TextEditingController(text: widget.pelanggan['address']);
  }

  @override
  void dispose() {
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
              TextField(
                controller: editAlamatController,
                maxLength: 200,
                decoration: const InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.location_on_outlined),
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('userId'); // Dapatkan userId

                    String editNamaPelanggan = editNamaPelangganController.text;
                    String editNomorTelpon = editNomorTelponController.text;
                    String editAlamat = editAlamatController.text;

                    if (editNamaPelanggan.isNotEmpty &&
                        editNomorTelpon.isNotEmpty &&
                        editAlamat.isNotEmpty) {
                      try {
                        final updatedPelanggan = Pelanggan(
                          id: widget.pelanggan['id'],
                          namaPelanggan: editNamaPelanggan,
                          nomorTelpon: editNomorTelpon,
                          alamat: editAlamat,
                          userId: userId!.toInt(),
                        );
                        await _dbHelper.updatePelanggan(updatedPelanggan);

                        // Data pelanggan diperbarui
                        final updatedPelangganFix = {
                          'id': widget.pelanggan['id'],
                          'name': editNamaPelangganController.text,
                          'phone': editNomorTelponController.text,
                          'address': editAlamatController.text,
                          'userId': userId!.toInt(),
                        };
                        Navigator.pop(context, updatedPelangganFix);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: const Text(
                              "Data Pelanggan berhasil diperbarui!",
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } catch (e) {
                        print("ID: ${widget.pelanggan['id']}, UserID: ${widget.pelanggan['userId']}");
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
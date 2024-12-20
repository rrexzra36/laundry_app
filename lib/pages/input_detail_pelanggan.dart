import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../models/pelanggan_model.dart';

class InputDetailPelanggan extends StatefulWidget {
  @override
  _InputDetailPelangganState createState() => _InputDetailPelangganState();
}

class _InputDetailPelangganState extends State<InputDetailPelanggan> {
  TextEditingController namaPelangganController = TextEditingController();
  TextEditingController nomorTelponController = TextEditingController();
  TextEditingController alamatController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan controller saat widget dihancurkan
    namaPelangganController.dispose();
    nomorTelponController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Input Detail Pelanggan'),
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
              // TextField untuk Nama Pelanggan
              TextField(
                controller: namaPelangganController,
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
                controller: nomorTelponController,
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
                child: const Text("Digunakan untuk kiri nota via WhatsApp",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16),

              // TextField untuk Deskripsi dengan batas maksimal 100 karakter
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: alamatController,
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
                ],
              ),


              // Tombol untuk menyimpan data Pelanggan
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    String namaPelanggan = namaPelangganController.text.trim();
                    String nomorTelpon = nomorTelponController.text.trim();
                    String alamat = alamatController.text.trim();

                    // Ambil userId dari SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    int? userId = prefs.getInt('userId'); // Dapatkan userId

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User tidak ditemukan. Silakan login kembali.")),
                      );
                      return;
                    }

                    if (namaPelanggan.isNotEmpty &&
                        nomorTelpon.isNotEmpty &&
                        alamat.isNotEmpty) {
                      Pelanggan pelanggan = Pelanggan(
                        namaPelanggan: namaPelanggan,
                        nomorTelpon: nomorTelpon,
                        alamat: alamat,
                        userId: userId, // Gunakan userId dari SharedPreferences
                      );

                      try {
                        await DatabaseHelper().tambahPelanggan(pelanggan);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Data Pelanggan berhasil disimpan!")),
                        );

                        namaPelangganController.clear();
                        nomorTelponController.clear();
                        alamatController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menyimpan data: $e")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Mohon lengkapi semua data")),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add),
                      SizedBox(width: 5),
                      Text("Tambahkan Pelanggan")
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
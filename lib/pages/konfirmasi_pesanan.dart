import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/pages/rinican_pesanan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';
import '../models/pesanan_model.dart';

class KonfirmasiPesanan extends StatefulWidget {
  final Map<String, dynamic> pelanggan;
  final Map<String, dynamic> layanan;
  final double totalPrice;
  final double weight;

  // Konstruktor untuk menerima data dari halaman sebelumnya
  KonfirmasiPesanan({
    required this.pelanggan,
    required this.layanan,
    required this.totalPrice,
    required this.weight,
  });

  @override
  _KonfirmasiPesananState createState() => _KonfirmasiPesananState();
}

class _KonfirmasiPesananState extends State<KonfirmasiPesanan> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    // Inisialisasi _selectedDate dengan durasi dari widget.layanan
    _selectedDate = DateTime.now().add(
      Duration(days: widget.layanan['layanan']['duration']),
    );
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime minimumDate = DateTime.now();
    DateTime tempDate = _selectedDate;
    TimeOfDay tempTime = _selectedTime;

    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),

              const Text(
                'Pilih Tanggal',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      tempDate.isBefore(minimumDate) ? minimumDate : tempDate,
                  minimumDate: minimumDate,
                  maximumDate: DateTime(2025),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Pilih Waktu',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Time Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                    tempDate.year,
                    tempDate.month,
                    tempDate.day,
                    tempTime.hour,
                    tempTime.minute,
                  ).isBefore(minimumDate)
                      ? minimumDate
                      : DateTime(
                          tempDate.year,
                          tempDate.month,
                          tempDate.day,
                          tempTime.hour,
                          tempTime.minute,
                        ),
                  use24hFormat: true, // Use 24-hour format
                  onDateTimeChanged: (DateTime newTime) {
                    tempTime = TimeOfDay.fromDateTime(newTime);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _selectedDate = tempDate;
                            _selectedTime = tempTime;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Konfirmasi',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);

    final formattedTime = DateFormat.Hm().format(
      DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
          _selectedTime.hour, _selectedTime.minute),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Konfirmasi Pesanan'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          // Customer Info
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pelanggan',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(widget.pelanggan['namaPelanggan'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.pelanggan['nomorTelepon'] ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Order Details
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rincian Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(height: 16, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Layanan',
                            style: TextStyle(color: Colors.grey)),
                        Text(
                            '${widget.layanan['layanan']['name']} (${widget.layanan['layanan']['type']})',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kuantitas',
                            style: TextStyle(color: Colors.grey)),
                        Text(
                            '${widget.weight.toInt()} kg x Rp. ${NumberFormat("#,##0", "id_ID").format(widget.layanan['layanan']['price'])}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Rp. ${NumberFormat("#,##0", "id_ID").format(widget.totalPrice.toInt())}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1),

                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                        'Rp. ${NumberFormat("#,##0", "id_ID").format(widget.totalPrice.toInt())}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Estimated Completion
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Estimasi selesai',
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      '$formattedDate $formattedTime WIB',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () => _selectDateTime(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                  ),
                  child: const Text("Ubah",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Total and Order Button
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Rp. ${NumberFormat("#,##0", "id_ID").format(widget.totalPrice.toInt())}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      // Mendapatkan userId yang login
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int? userId = prefs.getInt('userId');
                      userId ??= 0; // Pastikan userId tidak null

                      // Ambil ID pelanggan dan ID layanan
                      int pelangganId = widget.pelanggan['id'];
                      int layananId = widget.layanan['layanan']['id'];

                      // Ambil waktu yang dipilih
                      TimeOfDay waktu = _selectedTime;

                      // Ambil tanggal saat ini untuk format nota
                      String tanggalPesan =
                          DateFormat('ddMMyyyy').format(DateTime.now());

                      // Cari nomor urut terakhir berdasarkan tanggal
                      String lastNota =
                          await DatabaseHelper().getLastNota(tanggalPesan);
                      int nomorUrut = 1;

                      if (lastNota.isNotEmpty) {
                        // Ambil nomor urut dari nota terakhir, misalnya: INV-22112024-001
                        RegExp regExp =
                            RegExp(r'(\d{3})$'); // Menangkap 3 digit terakhir
                        Match? match = regExp.firstMatch(lastNota);

                        if (match != null) {
                          nomorUrut = int.parse(match.group(0)!) + 1;
                        }
                      }

                      // Format nota baru dengan nomor urut yang increment
                      String nota =
                          'INV-$tanggalPesan-${nomorUrut.toString().padLeft(3, '0')}';

                      // Print data yang dikirimkan
                      print('Pelanggan ID: $pelangganId');
                      print('Layanan ID: $layananId');
                      print('Tanggal Pesan: $_selectedDate');
                      print('Waktu Pesan: ${waktu.format(context)}');
                      print('Total Harga: ${widget.totalPrice}');
                      print('Nota: $nota');
                      print('User ID: $userId');

                      // Buat objek Pesanan
                      Pesanan pesanan = Pesanan(
                        pelangganId: pelangganId,
                        layananId: layananId,
                        tanggal: _selectedDate,
                        tanggalSelesai: DateTime.now(),
                        waktu: waktu,
                        berat: widget.weight.toInt(),
                        totalPrice: widget.totalPrice.toInt(),
                        status: 0,
                        nota: nota, // Setel nota
                        userId: userId,
                      );

                      // Simpan pesanan ke database
                      int pesananId =
                          await DatabaseHelper().tambahPesanan(pesanan);

                      // Lanjutkan ke halaman rincian pesanan atau lainnya
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RincianPesanan(pesananId: pesananId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text(
                      'PESAN',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

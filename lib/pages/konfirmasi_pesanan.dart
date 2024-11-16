import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/pages/rinican_pesanan.dart';

class KonfirmasiPesanan extends StatefulWidget {
  @override
  _KonfirmasiPesananState createState() => _KonfirmasiPesananState();
}

class _KonfirmasiPesananState extends State<KonfirmasiPesanan> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime minimumDate = DateTime.now();
    DateTime tempDate = _selectedDate;
    TimeOfDay tempTime = _selectedTime;

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),

              Text(
                'Pilih Tanggal',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempDate.isBefore(minimumDate)
                      ? minimumDate
                      : tempDate,
                  minimumDate: minimumDate,
                  maximumDate: DateTime(2025),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
              SizedBox(height: 16),

              Text(
                'Pilih Waktu',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
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

              Padding(padding: EdgeInsets.all(16),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pelanggan',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  'Bima',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '08816755293',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
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
                Text(
                  'Rincian Pesanan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Divider(height: 16, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Layanan', style: TextStyle(color: Colors.grey)),
                        Text('Reguler (Kiloan)',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kuantitas', style: TextStyle(color: Colors.grey)),
                        Text('3 kg x Rp 7.000', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total', style: TextStyle(color: Colors.grey)),
                        Text('Rp 21.000', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                Divider(height: 32, thickness: 1),

                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Rp 21.000',
                        style: TextStyle(
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
            padding: EdgeInsets.all(16.0),
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
                      'Rp. 21000',
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RincianPesanan()));
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

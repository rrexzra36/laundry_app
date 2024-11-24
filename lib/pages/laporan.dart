import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  DateTimeRange? _selectedDateRange;
  int? _totalPendapatan;
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Inisialisasi DatabaseHelper

  Future<void> _pickDateRange() async {
    DateTime now = DateTime.now();
    DateTime firstDateOfThisMonth = DateTime(now.year, now.month, 1);
    DateTime lastDateOfThisMonth = DateTime.now();

    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: firstDateOfThisMonth,
      lastDate: lastDateOfThisMonth,
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });

      // Hitung total pendapatan setelah memilih rentang tanggal
      await _calculatePendapatan();
    }
  }

  Future<void> _calculatePendapatan() async {
    if (_selectedDateRange != null) {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');

      String startDate =
      DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start);
      String endDate = DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end);

      print(startDate);
      print(endDate);

      // Ambil total pendapatan dari database
      int total = await _databaseHelper.getTotalPendapatanByTanggal(userId!.toInt(), startDate, endDate);
      setState(() {
        _totalPendapatan = total;
      });
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pendapatan'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDateRange == null
                          ? 'Pilih Rentang Tanggal'
                          : '${formatDate(_selectedDateRange!.start)} - ${formatDate(_selectedDateRange!.end)}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedDateRange == null) ...[
              const Expanded(
                child: Center(
                  child: Text(
                    'Laporan dapat ditampilkan dengan menentukan rentang tanggal yang diinginkan per bulan',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            if (_selectedDateRange != null) ...[
              const Row(
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green, size: 32),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Total pembayaran yang diterima berdasarkan rentang tanggal yang dipilih. Difilter dari tanggal pembayaran',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatDate(_selectedDateRange!.start)} - ${formatDate(_selectedDateRange!.end)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Pendapatan',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _totalPendapatan == null
                          ? 'Menghitung...'
                          : 'Rp. ${NumberFormat("#,##0", "id_ID").format(_totalPendapatan)}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

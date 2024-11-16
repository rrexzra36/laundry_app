import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  DateTimeRange? _selectedDateRange;

  Future<void> _pickDateRange() async {
    // Mendapatkan tanggal pertama dan terakhir bulan ini
    DateTime now = DateTime.now();
    DateTime firstDateOfThisMonth = DateTime(now.year, now.month, 1);
    DateTime lastDateOfThisMonth = DateTime.now();

    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      firstDate: firstDateOfThisMonth, // Tanggal pertama bulan ini
      lastDate: lastDateOfThisMonth,   // Tanggal terakhir bulan ini
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
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
            // Jika belum memilih tanggal, tampilkan pesan di tengah halaman
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
            // Menampilkan konten lain hanya jika _selectedDateRange sudah dipilih
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
                          '${_selectedDateRange!.start.day} ${_selectedDateRange!.start.month} ${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day} ${_selectedDateRange!.end.month} ${_selectedDateRange!.end.year}',
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
                      'Rp 63.000',
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

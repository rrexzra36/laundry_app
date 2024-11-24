import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laundryapp/pages/bottom_navbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/db_helper.dart';

class RincianPesanan extends StatefulWidget {
  final int pesananId;

  const RincianPesanan({Key? key, required this.pesananId}) : super(key: key);

  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  int _currentStage = 0; // Status awal pesanan
  late Map<String, dynamic> _pesananData = {};
  bool _isLoading = true; // Untuk menunggu data selesai diambil
  late int _selectedStage;

  @override
  void initState() {
    super.initState();
    _fetchPesananData();
  }

  final List<String> _stageMessagesTitle = [
    "Pesanan Diterima",
    "Pesanan Akan Diproses",
    "Pesanan Siap Diambil",
    "Pesanan Telah Selesai",
  ];

  final List<String> _stageMessages = [
    "Pesanan telah diterima dan akan diproses/ dikerjakan.",
    "Pesanan akan diproses/ dikerjakan oleh pegawai.",
    "Pesanan sudah selesai diproses/ dikerjakan dan sudah bisa diambil oleh pelanggan",
    "Status pembayarn akan diubah menjadi lunas dengan metode pembayaran tunai.\n\nPastikan pelanggan telah melakukan pembayaran",
  ];

  // Fungsi untuk menentukan teks berdasarkan status
  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return "Diterima";
      case 1:
        return "Dikerjakan";
      case 2:
        return "Siap Diambil";
      case 3:
        return "Selesai";
      default:
        return "Unknown";
    }
  }
  
  void launchWhatsApp() async {
    String phone = "62${_pesananData['nomorTelpon']}";
    String message = "Halo ${_pesananData['pelangganNama']}!👋,\n\nKami dari *_Laundree_* ingin menginformasikan bahwa pesanan laundry Anda ${_getStatusText(_pesananData['status'])}. Berikut detailnya:\n\n   🧾 Nota: ${_pesananData['nota']}\n   🧺 Status: ${_getStatusText(_pesananData['status'])}\n   💵 Total Pembayaran: Rp. ${NumberFormat("#,##0", "id_ID").format(_pesananData['totalHarga'])}\n   ⏰ Jam Operasional: 08.00 - 17.00 WIB\n\nJika ada pertanyaan atau memerlukan layanan tambahan, jangan ragu untuk menghubungi kami! Terima kasih telah menggunakan *_Laundree_*. 😊\n\n_Semoga hari Anda menyenangkan!_";

    final Uri url = Uri.parse(
        "https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Membuka di browser eksternal
      );
    } catch (e) {
      print("Gagal membuka WhatsApp: $e");
    }
  }

  void _onStageSelected(int stage) {
    if (stage < _currentStage) {
      // Show snackbar if trying to go to a previous state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Tidak bisa merubah ke status pesanan sebelumnya")),
      );
    } else if (stage > _currentStage) {
      // Store the selected stage and show modal for confirmation
      setState(() {
        _selectedStage = stage;
      });
      _showBottomModal(
          _stageMessagesTitle[stage], _stageMessages[stage], stage);
    }
  }

  Future<void> _updateStageInDatabase(int status) async {
    try {
      print('Id Pesanan : ${widget.pesananId}');
      print('Status Pesanan : $status');
      await DatabaseHelper().updatePesananById(widget.pesananId, status);
      setState(() {
        _currentStage = status; // Update UI setelah sukses
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui status pesanan: $e")),
      );
    }
  }

  void _showBottomModal(String messagesTitle, String messages, int stage) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    messagesTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    messages,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        Navigator.pop(context); // Tutup modal
                        await _updateStageInDatabase(stage); // Update database
                        if (stage == 3) _showCompletionDialog(); // Jika selesai
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'Konfirmasi',
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 64),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pesanan Selesai",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Pesanan Anda telah selesai diproses. Terima kasih!",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()),
                  );
                },
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text(
                  'DASHBOARD',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> _fetchPesananData() async {
    try {
      Map<String, dynamic> data =
      await DatabaseHelper().getPesananById(widget.pesananId);
      setState(() {
        _pesananData = data;
        _currentStage = _pesananData['status'];
        _isLoading = false;
        print('Data pesanan: $data');
      });
    } catch (e) {
      print('Error fetching pesanan data: $e');
      setState(() {
        _isLoading = false; // Hindari loading tanpa akhir
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pesanan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Pesanan'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final updatedStatusFix = {
              'status' : _pesananData['status'],
            };
            Navigator.pop(context, updatedStatusFix);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          _buildCustomerInfo(),
          const SizedBox(height: 16.0),
          _buildOrderStatus(),
          const SizedBox(height: 16.0),
          _buildOrderDetails(),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pelanggan', style: TextStyle(color: Colors.grey)),
                  Text(
                    _pesananData['pelangganNama'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    _pesananData['nomorTelpon'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: launchWhatsApp,
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text('Kirim Nota WA',
                    style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    return Container(
      width: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStageButton('Diterima', 0),
              _buildStageLine(0),
              _buildStageButton('Diproses', 1),
              _buildStageLine(1),
              _buildStageButton('Siap diambil', 2),
              _buildStageLine(2),
              _buildStageButton('Selesai', 3),
            ],
          ),
          const Divider(height: 32, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No Nota', style: TextStyle(color: Colors.grey)),
                  Text(_pesananData['nota'] ?? 'Nama tidak tersedia'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Tanggal Pesanan', style: TextStyle(color: Colors.grey)),
                  Text(_pesananData['tanggalPesan'] ?? 'Nama tidak tersedia'),
                  const SizedBox(height: 8),
                  const Text('Estimasi Selesai', style: TextStyle(color: Colors.grey)),
                  Text(_pesananData['tanggalSelesai'] ?? 'Nama tidak tersedia'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Layanan', style: TextStyle(color: Colors.grey)),
                  Text(_pesananData['layanan'] ?? 'Nama tidak tersedia'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kuantitas', style: TextStyle(color: Colors.grey)),
                  Text('${_pesananData['berat'] ?? 'Nama tidak tersedia'} kg x Rp. ${NumberFormat("#,##0", "id_ID").format(_pesananData['hargaLayanan'])}'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total', style: TextStyle(color: Colors.grey)),
                  Text('Rp. ${NumberFormat("#,##0", "id_ID").format(_pesananData['totalHarga'])}',),
                ],
              ),
            ],
          ),
          const Divider(height: 32, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL BIAYA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Rp. ${NumberFormat("#,##0", "id_ID").format(_pesananData['totalHarga'])}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageButton(String label, int stage) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _onStageSelected(stage),
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentStage >= stage ? Colors.blue : Colors.grey[300],
            shape: const CircleBorder(),
          ),
          child: Icon(
            _currentStage > stage ? Icons.check : Icons.circle,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _currentStage >= stage ? Colors.blue : Colors.grey,
            fontWeight:
            _currentStage == stage ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStageLine(int stage) {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 3,
              color: _currentStage > stage ? Colors.blue : Colors.grey[300],
            ),
            SizedBox(height: 20,)
          ],
        )
    );
  }
}

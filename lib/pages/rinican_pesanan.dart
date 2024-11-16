import 'package:flutter/material.dart';
import 'package:laundryapp/pages/bottom_navbar.dart';

import 'dashboard.dart';

class RincianPesanan extends StatefulWidget {
  @override
  State<RincianPesanan> createState() => _RincianPesananState();
}

class _RincianPesananState extends State<RincianPesanan> {
  int _currentStage =
      0; // 0: Diterima, 1: Diproses, 2: Siap diambil, 3: Selesai
  late int
      _selectedStage; // Temporarily store selected stage before confirmation
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
                      onPressed: () {
                        setState(() {
                          _currentStage = stage; // Update the stage only after button press
                        });

                        // If it's the "Selesai" state, show the completion dialog
                        if (stage == 3) {
                          Navigator.pop(context); // Close the bottom modal
                          _showCompletionDialog();
                        } else {
                          Navigator.pop(context); // Close the modal for other stages
                        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Pesanan'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
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
              const Column(
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
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {},
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
                  Text('No Nota', style: TextStyle(color: Colors.grey),),
                  Text('INV-12112024-001')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Tanggal Pesanan', style: TextStyle(color: Colors.grey),),
                  Text('12 Nov 2024 22:27'),
                  SizedBox(height: 8),
                  Text('Estimasi Selesai', style: TextStyle(color: Colors.grey),),
                  Text('12 Nov 2024 22:27'),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Layanan', style: TextStyle(color: Colors.grey)),
                  Text('Reguler (Kiloan)', style: TextStyle(fontSize: 14)),
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
          SizedBox(height: 8),
          Divider(height: 32, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BIAYA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Rp 21.000',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            primary: _currentStage >= stage ? Colors.blue : Colors.grey[300],
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
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
              Text("Pesanan Anda telah selesai diproses. Terima kasih!", textAlign: TextAlign.center,),
            ],
          ),
          actions: [
            Container(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()), // Navigate to Dashboard
                  );
                },
                icon: const Icon(Icons.home, color: Colors.white,),
                label: const Text(
                  'DASHBOARD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Pesanan {
  final int? id;
  final int pelangganId;
  final int layananId;
  final DateTime tanggal;
  final DateTime tanggalSelesai;
  final TimeOfDay waktu;
  final int berat;
  final int totalPrice;
  String? nota;
  final int status;
  final int userId;

  Pesanan({
    this.id,
    required this.pelangganId,
    required this.layananId,
    required this.tanggal,
    required this.tanggalSelesai,
    required this.waktu,
    required this.berat,
    required this.totalPrice,
    this.nota,
    required this.status,
    required this.userId,
  });

  // Mengubah Pesanan menjadi Map untuk penyimpanan di database
  Map<String, dynamic> toMap() {
    // Format waktu menggunakan TimeOfDay untuk menyimpan
    String formattedWaktu = "${waktu.hour}:${waktu.minute}"; // Format waktu "HH:mm"
    return {
      'pelangganId': pelangganId,
      'layananId': layananId,
      'tanggal': DateFormat('yyyy-MM-dd').format(tanggal),
      'tanggalSelesai': DateFormat('yyyy-MM-dd').format(tanggalSelesai),
      'waktu': formattedWaktu, // Gunakan format string
      'berat': berat,
      'totalPrice': totalPrice,
      'nota': nota,
      'status': status,
      'userId': userId,
    };
  }

  // Membuat Pesanan dari Map (untuk membaca dari database)
  factory Pesanan.fromMap(Map<String, dynamic> map) {
    // Parse waktu dari string
    List<String> waktuParts = map['waktu'].split(':');
    TimeOfDay waktu = TimeOfDay(hour: int.parse(waktuParts[0]), minute: int.parse(waktuParts[1]));

    return Pesanan(
      id: map['id'],
      pelangganId: map['pelangganId'],
      layananId: map['layananId'],
      tanggal: DateTime.parse(map['tanggal']),
      tanggalSelesai: DateTime.parse(map['tanggalSelesai']),
      waktu: waktu,
      berat: map['berat'],
      totalPrice: map['totalPrice'].toDouble(),
      nota: map['nota'],
      status: map['status'],
      userId: map['userId'],
    );
  }
}

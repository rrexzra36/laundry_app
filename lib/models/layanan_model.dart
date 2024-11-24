class Layanan {
  final int? id;
  final String jenisLayanan;
  final String namaLayanan;
  final int harga;
  final int durasi;
  final String satuanWaktu;
  final String? deskripsi;
  final int userId;

  Layanan({
    this.id,
    required this.jenisLayanan,
    required this.namaLayanan,
    required this.harga,
    required this.durasi,
    required this.satuanWaktu,
    this.deskripsi,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenisLayanan': jenisLayanan,
      'namaLayanan': namaLayanan,
      'harga': harga,
      'durasi': durasi,
      'satuanWaktu': satuanWaktu,
      'deskripsi': deskripsi,
      'userId': userId,
    };
  }

  factory Layanan.fromMap(Map<String, dynamic> map) {
    return Layanan(
      id: map['id'],
      jenisLayanan: map['jenisLayanan'],
      namaLayanan: map['namaLayanan'],
      harga: map['harga'],
      durasi: map['durasi'],
      satuanWaktu: map['satuanWaktu'],
      deskripsi: map['deskripsi'],
      userId: map['userId'],
    );
  }
}

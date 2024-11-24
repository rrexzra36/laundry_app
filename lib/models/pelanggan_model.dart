class Pelanggan {
  final int? id;
  final String namaPelanggan;
  final String nomorTelpon;
  final String alamat;
  final int userId;

  Pelanggan({
    this.id,
    required this.namaPelanggan,
    required this.nomorTelpon,
    required this.alamat,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaPelanggan': namaPelanggan,
      'nomorTelpon': nomorTelpon,
      'alamat': alamat,
      'userId': userId,
    };
  }

  static Pelanggan fromMap(Map<String, dynamic> map) {
    return Pelanggan(
      id: map['id'],
      namaPelanggan: map['namaPelanggan'],
      nomorTelpon: map['nomorTelpon'],
      alamat: map['alamat'],
      userId: map['userId'],
    );
  }
}
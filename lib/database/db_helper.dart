import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:laundryapp/models/user_model.dart';

import '../models/layanan_model.dart';
import '../models/pelanggan_model.dart';
import '../models/pesanan_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Membuat tabel user
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    // Membuat tabel pelanggan
    await db.execute('''
    CREATE TABLE pelanggan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      namaPelanggan TEXT NOT NULL,
      nomorTelpon TEXT NOT NULL,
      alamat TEXT NOT NULL,
      userId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
     )
    ''');

    // Membuat tabel layanan
    await db.execute('''
    CREATE TABLE layanan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      jenisLayanan TEXT NOT NULL,
      namaLayanan TEXT NOT NULL,
      harga INTEGER NOT NULL,
      durasi INTEGER NOT NULL,
      satuanWaktu TEXT NOT NULL,
      deskripsi TEXT,
      userId INTEGER NOT NULL,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
    )
    ''');

    // Membuat tabel pesanan
    await db.execute(''' 
    CREATE TABLE pesanan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pelangganId INTEGER NOT NULL,
      layananId INTEGER NOT NULL,
      tanggal DATE NOT NULL,
      tanggalSelesai DATE NOT NULL,
      waktu TIME NOT NULL,
      berat INTEGER NOT NULL,
      nota TEXT NOT NULL,
      status INTEGER NOT NULL,
      totalPrice INTEGER NOT NULL,
      userId INTEGER NOT NULL,
      FOREIGN KEY (pelangganId) REFERENCES pelanggan (id) ON DELETE CASCADE,
      FOREIGN KEY (layananId) REFERENCES layanan (id) ON DELETE CASCADE,
      FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<int> registerUser(User user) async {
    Database db = await database;
    return await db.insert('users', user.toMap());
  }

  // mendapatkan user dari email yang dimasukkan
  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // autentifikasi login
  Future<bool> loginUser(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return maps.isNotEmpty;
  }

  // mendapatkan fullName dari email
  Future<String?> getFullNameByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);  // Membuat objek User
      return user.fullName;  // Mengakses fullName dari objek User
    }
    return null;
  }

  // mendapatkan email dari userId login
  Future<String?> getEmailById(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'Id = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      User user = User.fromMap(maps.first);  // Membuat objek User
      return user.email;  // Mengakses fullName dari objek User
    }
    return null;
  }

  // Mendapatkan semua pelanggan
  Future<List<Pelanggan>> getAllPelanggan(int userId) async {
    Database db = await _instance.database;

    // Modifikasi query untuk memfilter berdasarkan userId
    final List<Map<String, dynamic>> maps = await db.query(
      'pelanggan',
      where: 'userId = ?',  // Menambahkan kondisi untuk mencocokkan userId
      whereArgs: [userId],   // Menggunakan userId dari login
    );

    return List.generate(maps.length, (i) => Pelanggan.fromMap(maps[i]));
  }

  // Tambahkan pelanggan baru (opsional untuk input pelanggan)
  Future<int> tambahPelanggan(Pelanggan pelanggan) async {
    Database db = await database;
    return await db.insert('pelanggan', pelanggan.toMap());
  }

  // edit data pelanggan
  Future<int> updatePelanggan(Pelanggan pelanggan) async {
    Database db = await database;
    return await db.update(
      'pelanggan',
      pelanggan.toMap(),
      where: 'id = ?', // Gunakan ID pelanggan sebagai kondisi
      whereArgs: [pelanggan.id],
    );
  }

  // Mendapatkan semua layanan
  Future<List<Layanan>> getAllLayanan(int userId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'layanan',            // Menambahkan kondisi untuk mencocokkan userId
      where: 'userId = ?',  // Menggunakan userId dari login
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) => Layanan.fromMap(maps[i]));
  }

  // Tambahkan layanan baru
  Future<int> tambahLayanan(Layanan layanan) async {
    Database db = await database;
    return await db.insert('layanan', layanan.toMap());
  }

  // edit data layanan
  Future<int> updateLayanan(Layanan layanan) async {
    Database db = await database;
    return await db.update(
      'layanan',
      layanan.toMap(),
      where: 'id = ?', // Gunakan ID pelanggan sebagai kondisi
      whereArgs: [layanan.id],
    );
  }

  // Tambah pesanan baru
  Future<int> tambahPesanan(Pesanan pesanan) async {
    Database db = await database;
    return await db.insert('pesanan', pesanan.toMap());
  }

  // Fungsi untuk update pesanan dengan nota baru
  Future<int> updatePesanan(Pesanan pesanan) async {
    Database db = await database;
    return await db.update(
      'pesanan',
      pesanan.toMap(),
      where: 'id = ?', // Gunakan ID pesanan sebagai kondisi
      whereArgs: [pesanan.id],
    );
  }

  // Update pesanan dengan id
  Future<int> updatePesananById(int id, int status) async {
    Database db = await database;
    return await db.update(
      'pesanan',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<String> getLastNota(String tanggalPesan) async {
    Database db = await database;

    // Cari nota terakhir dengan tanggal yang sama
    List<Map<String, dynamic>> result = await db.query(
      'pesanan',
      columns: ['nota'],
      where: 'nota LIKE ?',
      whereArgs: ['INV-$tanggalPesan%'],  // Cek nota dengan prefix INV-tanggal
      orderBy: 'nota DESC',  // Urutkan berdasarkan nota yang paling terbaru
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['nota'];
    } else {
      return '';
    }
  }

  Future<Map<String, dynamic>> getPesananById(int pesananId) async {
    Database db = await database;

    // Ambil data pesanan
    List<Map<String, dynamic>> pesananResult = await db.query(
      'pesanan',
      where: 'id = ?',
      whereArgs: [pesananId],
      limit: 1,
    );
    if (pesananResult.isEmpty) {
      throw Exception("Pesanan dengan ID $pesananId tidak ditemukan.");
    }
    print("Pesanan result: $pesananResult");

    final pesananData = pesananResult.first;
    int berat = pesananData['berat'];

    // Ambil data pelanggan
    List<Map<String, dynamic>> pelangganResult = await db.query(
      'pelanggan',
      where: 'id = ?',
      whereArgs: [pesananData['pelangganId']],
      limit: 1,
    );
    if (pelangganResult.isEmpty) {
      throw Exception("Pelanggan tidak ditemukan untuk pesanan ini.");
    }
    print("Pelanggan result: $pelangganResult");

    final pelangganData = pelangganResult.first;
    String pelangganNama = pelangganData['namaPelanggan'] as String;
    String nomorTelpon = pelangganData['nomorTelpon'] as String;

    // Ambil data layanan
    List<Map<String, dynamic>> layananResult = await db.query(
      'layanan',
      where: 'id = ?',
      whereArgs: [pesananData['layananId']],
      limit: 1,
    );
    if (layananResult.isEmpty) {
      throw Exception("Layanan tidak ditemukan untuk pesanan ini.");
    }
    print("Layanan result: $layananResult");

    final layananData = layananResult.first;
    String namaLayanan = layananData['namaLayanan'] as String;
    int harga = layananData['harga'];

    // Bangun hasil akhir
    final result = {
      'id': pesananData['id'] as int,
      'nota': pesananData['nota'] ?? '',
      'tanggalSelesai': pesananData['tanggal'] ?? '',
      'tanggalPesan': pesananData['tanggalSelesai'] ?? '',
      'status': pesananData['status'] ?? 0,
      'pelangganNama': pelangganNama,
      'nomorTelpon' : nomorTelpon,
      'layanan': namaLayanan,
      'hargaLayanan': harga,
      'berat': berat,
      'totalHarga': int.tryParse(pesananData['totalPrice'].toString()) ?? 0,
    };

    print("Final result: $result");

    return result;
  }

  // Mendapatkan semua pesanan dari userId
  Future<List<Map<String, dynamic>>> getAllPesanan(int userId) async {
    Database db = await database;

    // Query untuk mendapatkan data pesanan berdasarkan userId (bukan pelangganId)
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT 
      pesanan.id AS pesananId,
      pesanan.nota,
      pesanan.tanggal AS tanggalPesan,
      pesanan.tanggalSelesai,
      pesanan.waktu,
      pesanan.berat,
      pesanan.status,
      pesanan.totalPrice,
      pelanggan.namaPelanggan,
      pelanggan.nomorTelpon,
      layanan.namaLayanan,
      layanan.harga AS hargaLayanan
    FROM 
      pesanan
    INNER JOIN 
      pelanggan ON pesanan.pelangganId = pelanggan.id
    INNER JOIN 
      layanan ON pesanan.layananId = layanan.id
    WHERE 
      pesanan.userId = ?
  ''', [userId]);

    // Memformat hasil untuk setiap pesanan
    return results.map((result) {
      return {
        'pesananId': result['pesananId'],
        'nota': result['nota'],
        'tanggalPesan': result['tanggalPesan'],
        'tanggalSelesai': result['tanggalSelesai'],
        'waktu': result['waktu'],
        'berat': result['berat'],
        'status': result['status'],
        'totalPrice': result['totalPrice'],
        'namaPelanggan': result['namaPelanggan'],
        'nomorTelpon': result['nomorTelpon'],
        'namaLayanan': result['namaLayanan'],
        'hargaLayanan': result['hargaLayanan'],
      };
    }).toList();
  }

  // Mendapatkan total semua pendapatan dari total price
  Future<int> getTotalPendapatan(int userId) async {
    Database db = await database;

    // Query untuk menjumlahkan totalPrice berdasarkan userId
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT SUM(totalPrice) AS totalPendapatan
    FROM pesanan
    WHERE userId = ? AND
    status = 3
    ''', [userId]);

    // Jika ada hasil, kembalikan total pendapatan, jika tidak, kembalikan 0
    if (result.isNotEmpty && result.first['totalPendapatan'] != null) {
      return result.first['totalPendapatan'] as int;
    }
    return 0;
  }

  // Menghitung pendatakan dari total price dengan range tanggal tertentu
  Future<int> getTotalPendapatanByTanggal(
      int userId, String startDate, String endDate) async {
    Database db = await database;

    // Query untuk menjumlahkan totalPrice berdasarkan userId dan rentang tanggal
    List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT SUM(totalPrice) AS totalPendapatan
    FROM pesanan
    WHERE userId = ?
    AND status = 3
    AND tanggalSelesai BETWEEN ? AND ?
    ''', [userId, startDate, endDate]);

    // Jika ada hasil, kembalikan total pendapatan, jika tidak, kembalikan 0
    if (result.isNotEmpty && result.first['totalPendapatan'] != null) {
      return result.first['totalPendapatan'] as int;
    }
    return 0;
  }


}

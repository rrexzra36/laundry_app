import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/db_helper.dart';

class DetailProfile extends StatefulWidget {
  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  final DatabaseHelper _databaseHelper =
  DatabaseHelper(); // Inisialisasi DatabaseHelper
  String fullName = "";
  String emailUser = "";

  @override
  void initState() {
    super.initState();
    getFullNameFromPreferences(); // Ambil fullName saat widget diinisialisasi
    getEmailById();
  }

  Future<void> getFullNameFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFullName = prefs.getString('fullName');

    if (storedFullName != null) {
      setState(() {
        fullName = storedFullName; // Perbarui nilai fullName
      });
    }
  }

  Future<void> getEmailById() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    String? email = await _databaseHelper.getEmailById(userId!.toInt());
    if (email == null) {
      print("Email tidak ditemukan untuk userId: $userId");
      print(email);
    } else {
      setState(() {
        emailUser = email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Saya'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40, color: Colors.white),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(height: 10),
            Text(
              fullName.isNotEmpty ? fullName : "User",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              emailUser.toString().isNotEmpty ? emailUser : "Email",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Pemilik',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Add delete account logic here
              },
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                tileColor: Colors.red[100],
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      size: 32,
                      color: Colors.red,
                    ),
                  ],
                ),
                title: Text(
                  'Hapus Akun',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Hapus akun dan data terkait',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

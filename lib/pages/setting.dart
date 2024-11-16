import 'package:flutter/material.dart';
import 'package:laundryapp/pages/detail_profile.dart';
import 'package:laundryapp/pages/login.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun dan Pengaturan'),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('AKUN', style: TextStyle(color: Colors.grey)),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailProfile()));
                  },
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Row(
                        children: [
                          Text('Ezra'),
                          SizedBox(width: 8.0),
                          Container(
                            padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Pemilik',
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                      subtitle: Text('re.bimantara@gmail.com'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ),
                  ),
                )
              ],
            ),

            // Application Information Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text('TENTANG APLIKASI',
                      style: TextStyle(color: Colors.grey)),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.info, color: Colors.white),
                        ),
                        title: Text('Versi Aplikasi'),
                        subtitle: Text('1.0.0 Beta'),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.star, color: Colors.white),
                        ),
                        title: Text('Beri Penilaian dan Ulasan'),
                        subtitle:
                            Text('Berikan penilaian dan ulasan di Playstore'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.chat_rounded, color: Colors.white),
                        ),
                        title: Text('Masukkan dan Saran'),
                        subtitle: Text('Isi dan Kirim ke pihak Dev'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.transparent,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        _showCompletionDialog(context);
                      },
                      icon: const Icon(Icons.login),
                      label: const Text(
                        'KELUAR',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.red,
            child: Icon(Icons.logout, color: Colors.white, size: 32),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text("Apakah anda yakin ingin keluar?",
                  textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Container(
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

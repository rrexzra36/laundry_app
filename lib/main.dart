import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundryapp/pages/bottom_navbar.dart';
import 'package:laundryapp/pages/buat_pesanan.dart';
import 'package:laundryapp/pages/detail_profile.dart';
import 'package:laundryapp/pages/dump/coba_order.dart';
import 'package:laundryapp/pages/dashboard.dart';
import 'package:laundryapp/pages/home.dart';
import 'package:laundryapp/pages/konfirmasi_pesanan.dart';
import 'package:laundryapp/pages/login.dart';
import 'package:laundryapp/pages/register.dart';
import 'package:laundryapp/pages/single_order.dart';
import 'package:laundryapp/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Laundry App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          initialRoute: "/",
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
    case "/register":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Register();
      });
    case "/login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login();
      });
    case "/single-order":
      return MaterialPageRoute(builder: (BuildContext context) {
        return SingleOrder();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      });
  }
}
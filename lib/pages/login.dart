import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import 'bottom_navbar.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan userId ke Shared Preferences
  Future<void> _saveUserIdToPreferences(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

// Simpan userId setelah login berhasil
  void loginUser(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      bool isAuthenticated = await _dbHelper.loginUser(email, password);

      if (isAuthenticated) {
        User? user = await _dbHelper.getUserByEmail(email);

        if (user != null) {
          // Simpan userId ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', user.id!);
          await prefs.setString('fullName', user.fullName);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBar()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Incorrect email or password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: -20.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/washing_machine_illustration.png",
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Log in to your account",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 180.0,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Section
                        Text('Email'),
                        SizedBox(height: 5.0),
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(74, 77, 84, 0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.primaryColor,
                                ),
                              ),
                              labelText: "Enter your email",
                              hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(105, 108, 121, 0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        // Password Sction
                        Text('Password'),
                        SizedBox(height: 5.0),
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(74, 77, 84, 0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Constants.primaryColor,
                                ),
                              ),
                              labelText: "Enter your password",
                              hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(105, 108, 121, 0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),

                        // Forgot Password Section
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Forgot Password?",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppButton(
                          type: ButtonType.PRIMARY,
                          text: "Log In",
                          onPressed: () {
                            loginUser(context);
                          },
                        ),
                      ],
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
}

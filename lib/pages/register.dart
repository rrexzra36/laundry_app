import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../database/db_helper.dart';
import '../models/user_model.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void registerUser(BuildContext context) async {
    String fullName = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Validasi input pengguna
    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon isi semua kolom")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok")),
      );
      return;
    }

    // Print data input user ke konsol
    print("Full Name: $fullName");
    print("Email: $email");
    print("Password: $password");

    DatabaseHelper db = DatabaseHelper();
    User newUser = User(
      fullName: fullName,
      email: email,
      password: password,
    );

    try {
      await db.registerUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil, silahkan login", style: TextStyle(color: Colors.white),), backgroundColor: Colors.green,),
      );
      Navigator.of(context).pushNamed("/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.toString()}")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            SingleChildScrollView(
              child: Column(
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
                          "Create your account",
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

                          // Full name Section
                          Text('Fullname'),
                          SizedBox(height: 5.0),
                          Container(
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                labelText: "Enter your fullname",
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),

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
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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

                          // Confirm Password Section
                          Text('Confirm Password'),
                          SizedBox(height: 5.0),
                          Container(
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              obscureText: true,
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                labelText: "Enter your confirm password",
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Color.fromRGBO(105, 108, 121, 0.7),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          // Button Register
                          const SizedBox(height: 20.0),
                          AppButton(
                            type: ButtonType.PRIMARY,
                            text: "Register",
                            onPressed: () {
                              registerUser(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

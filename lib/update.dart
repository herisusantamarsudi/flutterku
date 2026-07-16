import 'package:flutter/material.dart';
import 'package:flutterku/config/api.dart';
//import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'dart:convert';
//import 'package:flutterku/login.dart';

class Update extends StatefulWidget {
  //final dynamic user;

  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String msg = "";

  late TextEditingController idController;
  late TextEditingController userController;
  late TextEditingController passController;
  late TextEditingController mailController;

  @override
  void initState() {
    super.initState();
    // final data = widget.user[0]; // data dari parameter
    // idController = TextEditingController(text: data['id'].toString());
    // userController = TextEditingController(text: data['username']);
    // passController = TextEditingController(text: data['password']);
    // mailController = TextEditingController(text: data['email']);
  }

  @override
  void dispose() {
    idController.dispose();
    userController.dispose();
    passController.dispose();
    mailController.dispose();
    super.dispose();
  }

  void _update() async {
    var response = await http.post(
      Uri.parse(ApiConfig.ubahUser),
      body: {
        "id": idController.text, // ← kirim id
        "username": userController.text,
        "password": passController.text,
        "email": mailController.text,
      },
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/Loginpage');
    } else {
      setState(() {
        msg = "Update gagal!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      Api.getImage(
                        "profile/logo_delayota.png",
                      ), // ganti dengan URL gambar Anda
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover, // biar proporsional
                    ),
                    Text(
                      "Welcome, ${userController.text}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    _gap(),

                    // Username
                    TextFormField(
                      controller: userController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Wajib diisi" : null,
                    ),
                    _gap(),

                    // Password
                    TextFormField(
                      controller: passController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? "Minimal 6 karakter"
                          : null,
                    ),
                    _gap(),

                    // Email
                    TextFormField(
                      controller: mailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Wajib diisi";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return "Email tidak valid";
                        }
                        return null;
                      },
                    ),
                    _gap(),

                    // hidden id
                    TextFormField(
                      controller: idController,
                      readOnly: true,
                      //enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'NIS',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch, // biar full lebar
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Update ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _update();
                              }
                            },
                          ),
                          const SizedBox(height: 10), // jarak antar tombol

                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/Homepage',
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    Text(msg, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

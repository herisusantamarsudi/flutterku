import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/config/data.dart';
import 'package:flutterku/screen/member.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UbahUser extends StatefulWidget {
  const UbahUser({super.key});

  @override
  State<UbahUser> createState() => _UbahUserState();
}

class _UbahUserState extends State<UbahUser> {
  bool _isPasswordVisible = false;
  String valstring = "";

  late Future<List<UserData>> futureUser;
  final TextEditingController id_reg = TextEditingController();
  final TextEditingController user_reg = TextEditingController();
  final TextEditingController pass_reg = TextEditingController();
  final TextEditingController mail_reg = TextEditingController();

  String msg = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
    _loadUser();
  }

  Future<List<UserData>> fetchUser() async {
    final response = await http.get(Uri.parse(ApiConfig.ambilUser));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["status"] == "success") {
        List<dynamic> data = jsonResponse["data"];
        return data.map((item) => UserData.fromJson(item)).toList();
      } else {
        throw Exception("Gagal ambil data: ${jsonResponse['message']}");
      }
    } else {
      throw Exception("Failed to load data from API");
    }
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        valstring = prefs.getString('valstring') ?? "";
      });
      final response = await http.get(Uri.parse(ApiConfig.ambilUser));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse["status"] == "success") {
          List<dynamic> data = jsonResponse["data"];
          final users = data.map((item) => UserData.fromJson(item)).toList();

          // cari user berdasarkan valstring (username yang login)
          final currentUser = users.firstWhere(
            (u) => u.user == valstring,
            orElse: () => users[0], // fallback kalau tidak ketemu
          );

          setState(() {
            //id_reg.text = User.id;
            user_reg.text = currentUser.user;
            mail_reg.text = currentUser.email;
            // pass_reg.text = currentUser.password; // kalau API mengirim password
          });
        }
      }
    } catch (e) {
      print("Error ambil data user: $e");
    }
  }

  void _regis() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final body = {
        "id": userId ?? "",
        "username": user_reg.text,
        "email": mail_reg.text,
      };

      if (pass_reg.text.isNotEmpty) {
        body["password"] = pass_reg.text;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.ubahUser), // arahkan ke update.php
        body: body,
      );

      final result = json.decode(response.body);

      if (result["status"] == "success") {
        setState(() {
          msg = "Update berhasil!";
        });
        Navigator.pushReplacementNamed(context, '/MemberScreen');
      } else {
        setState(() {
          msg = "Gagal update: ${result['message']}";
        });
      }
    } catch (e) {
      setState(() {
        msg = "Terjadi error: $e";
      });
    }
  }

  @override
  void dispose() {
    id_reg.dispose();
    user_reg.dispose();
    pass_reg.dispose();
    mail_reg.dispose();
    super.dispose();
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      Api.getImage("profile/logo_delayota.png"),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    _gap(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Welcome, $valstring",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Enter your email and password to continue.",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: user_reg,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Masukkan username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: pass_reg,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: mail_reg,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        bool emailValid = RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+",
                        ).hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Masukkan email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      controller: id_reg,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'NIS',
                        hintText: 'Masukkan username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _regis();
                              }
                            },
                          ),
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
                                'Kembali',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemberScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _gap(),
                    Text(
                      msg,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    _gap(),

                    FutureBuilder<List<UserData>>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error}"),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Tidak ada data"));
                        }

                        final userList = snapshot.data!;

                        // ⬇️ Column HARUS di-return dari dalam builder
                        return Column(
                          children: userList.map((user) {
                            return ListTile(
                              title: Text(user.user),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.id.toString()),
                                  Text(user.password),
                                  Text(user.email),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
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

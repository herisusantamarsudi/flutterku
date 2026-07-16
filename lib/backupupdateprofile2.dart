import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/config/data.dart';
import 'package:flutterku/screen/admin.dart';
import 'package:flutterku/screen/member.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UbahProfile2 extends StatefulWidget {
  const UbahProfile2({super.key});

  @override
  State<UbahProfile2> createState() => _UbahProfile2State();
}

class _UbahProfile2State extends State<UbahProfile2> {
  late Future<UserData?> futureUser;

  final TextEditingController id_reg = TextEditingController();
  final TextEditingController user_reg = TextEditingController();
  final TextEditingController mail_reg = TextEditingController();
  final TextEditingController pass_reg = TextEditingController();

  String msg = "";
  String valstring = "";

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<UserData?> fetchUser() async {
    final response = await http.get(Uri.parse(ApiConfig.ambilUser));
    final prefs = await SharedPreferences.getInstance();
    valstring = prefs.getString('valstring') ?? "";

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["status"] == "success") {
        List<dynamic> data = jsonResponse["data"];
        final users = data.map((item) => UserData.fromJson(item)).toList();

        final currentUser = users.firstWhere(
          (u) => u.user == valstring,
          // orElse: () => UserData(id: -1, user: "", password: "", email: ""),
        );

        if (currentUser.id != -1) {
          setState(() {
            id_reg.text = currentUser.id.toString();
            user_reg.text = currentUser.user;
            mail_reg.text = currentUser.email;
            pass_reg.text = "";
          });
          return currentUser;
        }
      } else {
        throw Exception("Gagal ambil data: ${jsonResponse['message']}");
      }
    }
    throw Exception("Failed to load data from API");
  }

  void _regis() async {
    try {
      final body = {
        "id": id_reg.text,
        "username": user_reg.text,
        "email": mail_reg.text,
      };

      if (pass_reg.text.isNotEmpty) {
        body["password"] = pass_reg.text;
      }

      final response = await http.post(
        Uri.parse(ApiConfig.ubahUser),
        body: body,
      );

      final result = json.decode(response.body);

      if (result["status"] == "success") {
        setState(() {
          msg = "Update berhasil!";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Data"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<UserData?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User tidak ditemukan"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: user_reg,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: mail_reg,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: pass_reg,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password Baru"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _regis, child: const Text("Update")),
                const SizedBox(height: 10),
                Text(msg),
              ],
            ),
          );
        },
      ),
    );
  }
}

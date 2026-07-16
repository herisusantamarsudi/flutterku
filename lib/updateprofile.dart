import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/config/data.dart';
import 'package:flutterku/screen/member.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class UbahProfile extends StatefulWidget {
  const UbahProfile({super.key});

  @override
  State<UbahProfile> createState() => _UbahProfileState();
}

class _UbahProfileState extends State<UbahProfile> {
  late Future<UserData?> futureUser;

  final TextEditingController id_reg = TextEditingController();
  final TextEditingController user_reg = TextEditingController();
  final TextEditingController namalengkap_reg = TextEditingController();
  final TextEditingController mail_reg = TextEditingController();
  final TextEditingController telpon_reg = TextEditingController();
  final TextEditingController profile_reg = TextEditingController();
  final TextEditingController pass_reg = TextEditingController();

  String msg = "";
  String valstring = "";
  String? userId;
  File? _imageFile;
  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  Future<UserData?> fetchUser() async {
    final response = await http.get(Uri.parse(ApiConfig.ambilUser));
    final prefs = await SharedPreferences.getInstance();
    valstring = prefs.getString('valstring') ?? "";
    userId = prefs.getString('id_user');

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
            namalengkap_reg.text = currentUser.namalengkap;
            mail_reg.text = currentUser.email;
            telpon_reg.text = currentUser.telpon;
            profile_reg.text = currentUser.profile;
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

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _update() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.ubahUser),
      );

      request.fields['id'] = id_reg.text;
      request.fields['username'] = user_reg.text;
      request.fields['namalengkap'] = namalengkap_reg.text;
      request.fields['email'] = mail_reg.text;
      request.fields['telpon'] = telpon_reg.text;

      if (pass_reg.text.isNotEmpty) {
        request.fields['password'] = pass_reg.text;
      }

      // 🔥 upload gambar kalau ada
      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // field name di backend
            _imageFile!.path,
            filename: "${id_reg.text}.jpg", // nama file sesuai id
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final result = json.decode(responseBody);

      if (result["status"] == "success") {
        setState(() {
          msg = "Update berhasil!";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MemberScreen()),
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
              MaterialPageRoute(builder: (context) => MemberScreen()),
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
                GestureDetector(
                  onTap: _pickImage, // pilih gambar baru
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider
                        : NetworkImage(
                            // Api.getImage("profile/heri.png"),
                            Api.getImage("profile/$userId.jpg"),
                          ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: user_reg,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: namalengkap_reg,
                  decoration: const InputDecoration(labelText: "Nama Lengkap"),
                ),
                TextField(
                  controller: mail_reg,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: telpon_reg,
                  decoration: const InputDecoration(labelText: "Nomor Telepon"),
                ),

                TextField(
                  controller: pass_reg,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText:
                        "Password Baru (kosongkan jika tidak ubah password)",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _update, child: const Text("Update")),
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

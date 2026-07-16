import 'package:flutter/material.dart';
//import 'package:flutterku/updateprofile.dart';
import 'package:flutterku/updateuser.dart';
import 'package:flutterku/config/data.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/screen/admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserList extends StatefulWidget {
  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<UserData>> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  // Fungsi ambil data dari API PHP
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminScreen()),
              ); // kembali ke halaman sebelumnya
            },
          ),
          title: const Text(
            "Daftar Pengguna",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: FutureBuilder<List<UserData>>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Tidak ada data"));
              }

              final userList = snapshot.data!;

              return ListView.separated(
                itemCount: userList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final user = userList[index];

                  return Dismissible(
                    key: ValueKey(user.id),
                    direction: DismissDirection
                        .endToStart, // geser ke kiri untuk delete
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text(
                            "Yakin ingin menghapus pengguna ${user.user}?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) async {
                      setState(() {
                        userList.removeAt(index); // hapus dari list UI
                      });

                      // TODO: panggil API untuk delete dari database
                      final response = await http.post(
                        Uri.parse(ApiConfig.hapusUser),
                        body: {"id": user.id.toString()},
                      );

                      if (response.statusCode == 200) {
                        final jsonResponse = json.decode(response.body);
                        print(user.id);
                        // print("Delete status: ${response.statusCode}");
                        // print(
                        //   "Delete body: ${response.body}",
                        // ); // <== cek isi respons

                        if (jsonResponse["status"] != "success") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal hapus data dari server"),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error koneksi ke server")),
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24, // ukuran lingkaran
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(
                          Api.getImage(
                            "profile/heri.png",
                          ), // otomatis pakai base url
                          // fit: BoxFit.cover,
                        ),
                        onBackgroundImageError: (_, __) {
                          // fallback kalau gambar gagal dimuat
                        },
                      ),
                      title: Text(user.user),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("NIS            : ${user.id}"),
                          //Text("Password  : ${user.password}"),
                          Text("Email         : ${user.email}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UbahUser(id: user.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

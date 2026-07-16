import 'package:flutter/material.dart';
import 'package:flutterku/config/barangdata.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/screen/admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BarangList extends StatefulWidget {
  @override
  State<BarangList> createState() => _BarangListState();
}

class _BarangListState extends State<BarangList> {
  late Future<List<BarangData>> futureBarang;

  @override
  void initState() {
    super.initState();
    futureBarang = fetchBarang();
  }

  // Fungsi ambil data dari API PHP
  Future<List<BarangData>> fetchBarang() async {
    final response = await http.get(Uri.parse(ApiConfig.ambilData));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["status"] == "success") {
        List<dynamic> data = jsonResponse["data"];
        return data.map((item) => BarangData.fromJson(item)).toList();
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
          child: FutureBuilder<List<BarangData>>(
            future: futureBarang,
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

              final barangList = snapshot.data!;

              return ListView.separated(
                itemCount: barangList.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  final barang = barangList[index];

                  return ListTile(
                    title: Text(barang.nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga:${barang.harga} rupiah"),
                        Text("Jumlah: ${barang.jumlah}"),
                      ],
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

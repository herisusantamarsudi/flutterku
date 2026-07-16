//import 'package:flutterku/login.dart';
import 'package:flutterku/config/api.dart';
//import 'package:flutterku/home.dart';
import 'package:flutterku/main.dart';
import 'package:flutterku/screen/baranglist.dart';
import 'package:flutterku/screen/userlist.dart';
// import 'package:flutterku/updateprofile.dart';
import 'package:flutterku/widgets/button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
//import 'package:flutterku/update.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  //final dynamic user; // bisa Map, List, atau model

  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String valstring = "";

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      valstring = prefs.getString('valstring') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil data user dari parameter

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: const GradientBoxBorder(
                  width: 3,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.redAccent, Colors.purple],
                  ),
                ),
              ),
              position: DecorationPosition.foreground,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ExtendedImage.network(
                  Api.getImage("profile/logo_delayota.png"),
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // --- tampilkan username login dari prefs
            Text(
              "Welcome, $valstring",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const Gap(20),
            CustomButton(
              label: "Kelola produk",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BarangList()),
                );
              },
            ),
            const Gap(20),
            CustomButton(
              label: "Kelola User",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserList()),
                );
              },
            ),
            const Gap(20),
            CustomButton(
              label: "Sign out",
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('valstring'); // hapus data login

                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

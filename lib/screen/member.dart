//import 'package:flutterku/home.dart';
import 'package:flutterku/config/api.dart';
import 'package:flutterku/login.dart';
import 'package:flutterku/main.dart';
//import 'package:flutterku/screen/baranglist.dart';
import 'package:flutterku/screen/baranglistmember.dart';
import 'package:flutterku/updateprofile.dart';
import 'package:flutterku/widgets/button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
//import 'package:gap/gap.dart';
//import 'package:flutterku/update.dart';

import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberScreen extends StatefulWidget {
  //final dynamic user; // bisa Map, List, atau model

  const MemberScreen({super.key});
  //const AdminScreen({super.key});
  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  String valstring = "";
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      valstring = prefs.getString('valstring') ?? "";
      userId = prefs.getString('id_user');
    });
  }

  @override
  Widget build(BuildContext context) {
    // ambil username dengan aman

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
                  //'https://images.pexels.com/photos/846741/pexels-photo-846741.jpeg?auto=compress&cs=tinysrgb&w=600',
                  //'http://delayota.byethost11.com/flutterku/images/profile/logo_delayota.png',
                  Api.getImage("profile/$userId.jpg"),
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                ),
              ),
            ),
            // --- tampilkan username login
            Text(
              //"Welcome,$username,$email,$level,$password,$id",
              "Welcome,$valstring",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "lihat produk",
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BarangListMember()),
                );
              },
            ),

            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            CustomButton(
              label: "update",
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UbahProfile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignInPage1()),
  );
}

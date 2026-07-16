import 'package:flutterku/config/api.dart';
import 'package:flutterku/login.dart';
import 'package:flutterku/widgets/button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<List> getData() async {
    final response = await http.post(Uri.parse(ApiConfig.login));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ExtendedImage.network(
                          Api.getImage(
                            "profile/halaman_delayota.jpeg",
                          ), // otomatis pakai base url
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 1],
                            colors: [
                              Colors.transparent,
                              const Color(0xff000000).withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMA Negeri 8 Yogyakarta',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          Gap(4),
                          Text(
                            'Hakarya Gora Anggatra Negara',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Center(
              child: Text(
                "Selamat datang tamu, untuk menikmati layanan kami, silahkan login",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center, // tetap rapih kalau teks panjang
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign in",
              onPressed: () async {
                goToLogin(context);
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign up",
              onPressed: () async {
                Navigator.pushReplacementNamed(context, '/Signuppage');
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

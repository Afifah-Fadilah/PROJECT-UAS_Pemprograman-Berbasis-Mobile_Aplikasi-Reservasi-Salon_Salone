import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_salon/screens/home/main_page.dart';
import 'package:project_salon/screens/auth/login_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EE),
      body: Stack(
        children: [
          // 🖼️ Gambar di kanan atas (ukuran menyesuaikan lebar layar)
          Align(
            alignment: const Alignment(0, -0.7), // 0: tengah, -1: paling atas
            child: Image.asset(
              "assets/images/intro.png",
              width: screenWidth * 0.8, // tetap responsif
              fit: BoxFit.contain,
            ),
          ),

          // 📄 Konten utama
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo di kiri atas
                Image.asset(
                  "assets/images/logo-nama.png",
                  width: screenWidth * 0.2, // 30% dari lebar layar
                ),

                const Spacer(), // Dorong konten ke bawah layar

                // Teks sambutan
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang di Saloné!",
                        style: GoogleFonts.mulish(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tempat terbaik untuk perawatan dan kecantikanmu.\n"
                        "- Booking salon & spa dengan mudah\n"
                        "- Lihat promo dan diskon menarik",
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.25),

                // 🔘 Tombol ke MainScreen
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mulai Sekarang",
                          style: GoogleFonts.mulish(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.08),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

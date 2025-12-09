import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_salon/screens/auth/register_page.dart';
// ignore: unused_import
import 'package:project_salon/screens/home/home_page.dart';
import 'package:project_salon/screens/home/main_page.dart';
import 'package:project_salon/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Halaman Login
// ignore: use_key_in_widget_constructors
class LoginPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  // Controller untuk ambil nilai input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi login dengan API
  void _login() async {
    final result = await AuthService.login(
        _emailController.text, _passwordController.text);

    if (result["success"] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'user_id', int.parse(result["data"]['id'].toString())); // ✅ BENAR
      await prefs.setString("user_name", result["data"]["name"]);
      await prefs.setString("user_email", result["data"]["email"]);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6EE),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔸 Gambar ilustrasi
              Transform.translate(
                offset: const Offset(-20, 15),
                child: Image.asset(
                  "assets/images/login.png",
                  width: 170,
                ),
              ),
              // 🔸 Teks sambutan
              Text(
                "Masuk Sekarang!",
                style: GoogleFonts.mulish(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Tampil percaya diri setiap hari dengan Saloné.",
                style: GoogleFonts.mulish(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 25),

              // 🔸 Input Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: "Email",
                  labelStyle: GoogleFonts.mulish(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔸 Input Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: "Kata Sandi",
                  labelStyle: GoogleFonts.mulish(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lupa kata sandi?",
                    style: GoogleFonts.mulish(
                      color: Colors.pink[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // 🔸 Tombol LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Masuk",
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔸 Garis pembatas "OR"
              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Atau",
                      style: GoogleFonts.mulish(color: Colors.grey[700]),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),

              // 🔸 Tombol Google Sign-In
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/google.png",
                    width: 23,
                  ),
                  label: Text(
                    "Lanjutkan dengan Google",
                    style: GoogleFonts.mulish(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 🔸 Teks signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum memiliki akun? ",
                    style: GoogleFonts.mulish(color: Colors.grey[700]),
                  ),
                  GestureDetector(
                    onTap: () {
                      // nanti diarahkan ke halaman signup
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Daftar",
                      style: GoogleFonts.mulish(
                        color: Colors.pink[400],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

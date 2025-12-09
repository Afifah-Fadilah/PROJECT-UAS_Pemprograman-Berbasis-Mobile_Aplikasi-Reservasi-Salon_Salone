import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';

class ServicesService {
  static const String url = "http://10.0.2.2/uas-pbm/salon_api/services.php";

  static Future<List<Service>> fetchServices() async {
    try {
      print("🌐 Fetching dari: $url"); // ✅ DEBUG
      
      final response = await http.get(Uri.parse(url));
      
      print("📡 Status code: ${response.statusCode}"); // ✅ DEBUG
      print("📦 Response body: ${response.body}"); // ✅ DEBUG

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        
        print("✅ Total data dari API: ${data.length}"); // ✅ DEBUG

        return data.map((e) {
          print("🔧 Parsing: ${e['name']}"); // ✅ DEBUG
          return Service(
            id: int.parse(e['id'].toString()),
            name: e['name'],
            price: int.parse(e['price'].toString().split('.')[0]), // ✅ Hapus desimal
            rating: double.parse(e['rating'].toString()),
            reviews: int.parse(e['reviews'].toString()),
            category: e['category'],
            image: e['image'],
            description: e['description'],
            duration: e['duration'],
            isBestSeller: e['is_best_seller'] == "1",
          );
        }).toList();
      } else {
        throw Exception("❌ Gagal mengambil layanan. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error di fetchServices: $e");
      rethrow;
    }
  }
}
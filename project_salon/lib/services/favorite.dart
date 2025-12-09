import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';

class FavoriteService {
  static const String baseUrl = "http://10.0.2.2/uas-pbm/salon_api";

  // ✅ TAMBAH - Hitung jumlah favorit
  static Future<int> getFavoriteCount(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites.php?action=count&user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return int.parse(data['count'].toString());
        }
      }
      return 0;
    } catch (e) {
      print("❌ Error getFavoriteCount: $e");
      return 0;
    }
  }

  // ✅ Ambil semua favorit user
  static Future<List<Service>> getFavorites(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites.php?user_id=$userId'),
      );

      print("📡 Response favorites: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final List serviceList = data['data'];
          return serviceList.map((e) => Service(
            id: int.parse(e['id'].toString()),
            name: e['name'],
            price: int.parse(e['price'].toString().split('.')[0]),
            rating: double.parse(e['rating'].toString()),
            reviews: int.parse(e['reviews'].toString()),
            category: e['category'],
            image: e['image'],
            description: e['description'],
            duration: e['duration'],
            isBestSeller: e['is_best_seller'] == "1",
          )).toList();
        }
      }
      return [];
    } catch (e) {
      print("❌ Error getFavorites: $e");
      return [];
    }
  }

  // ✅ Tambah favorit
  static Future<bool> addFavorite(int userId, int serviceId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites.php'),
        body: {
          'user_id': userId.toString(),
          'service_id': serviceId.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error addFavorite: $e");
      return false;
    }
  }

  // ✅ Hapus favorit
  static Future<bool> removeFavorite(int userId, int serviceId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites.php'),
        body: {
          'user_id': userId.toString(),
          'service_id': serviceId.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error removeFavorite: $e");
      return false;
    }
  }
}
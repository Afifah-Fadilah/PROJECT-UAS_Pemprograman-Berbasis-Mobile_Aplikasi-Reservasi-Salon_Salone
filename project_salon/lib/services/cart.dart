import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';
import '../models/cart_model.dart';

class CartService {
  static const String baseUrl = "http://10.0.2.2/uas-pbm/salon_api";

  // ✅ Ambil semua cart user
  static Future<List<CartItem>> getCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart.php?user_id=$userId'),
      );

      print("📡 Response cart: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final List cartList = data['data'];
          return cartList.map((item) {
            final serviceData = item['service'];
            return CartItem(
              service: Service(
                id: int.parse(serviceData['id'].toString()),
                name: serviceData['name'],
                price: int.parse(serviceData['price'].toString().split('.')[0]),
                rating: double.parse(serviceData['rating'].toString()),
                reviews: int.parse(serviceData['reviews'].toString()),
                category: serviceData['category'],
                image: serviceData['image'],
                description: serviceData['description'],
                duration: serviceData['duration'],
                isBestSeller: serviceData['is_best_seller'] == "1",
              ),
              quantity: int.parse(item['quantity'].toString()),
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("❌ Error getCart: $e");
      return [];
    }
  }

  // ✅ Tambah item ke cart
  static Future<bool> addToCart(int userId, int serviceId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart.php'),
        body: {
          'user_id': userId.toString(),
          'service_id': serviceId.toString(),
          'quantity': quantity.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error addToCart: $e");
      return false;
    }
  }

  // ✅ Update quantity
  static Future<bool> updateQuantity(int userId, int serviceId, int quantity) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cart.php'),
        body: {
          'user_id': userId.toString(),
          'service_id': serviceId.toString(),
          'quantity': quantity.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error updateQuantity: $e");
      return false;
    }
  }

  // ✅ Kosongkan cart (setelah checkout)
  static Future<bool> clearCart(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart.php'),
        body: {
          'user_id': userId.toString(),
        },
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error clearCart: $e");
      return false;
    }
  }
}
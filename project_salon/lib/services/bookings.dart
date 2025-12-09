import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';
import '../models/service_model.dart';

class BookingService {
  static const String baseUrl = "http://10.0.2.2/uas-pbm/salon_api";

  // ✅ TAMBAH - Hitung jumlah booking
  static Future<int> getBookingCount(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings.php?action=count&user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return int.parse(data['count'].toString());
        }
      }
      return 0;
    } catch (e) {
      print("❌ Error getBookingCount: $e");
      return 0;
    }
  }
  
  // ✅ Ambil semua booking user
  static Future<List<Booking>> getBookings(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings.php?user_id=$userId'),
      );

      print("📡 Response bookings: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          final List bookingList = data['data'];
          return bookingList.map((bookingData) {
            return Booking(
              id: bookingData['id'],
              customerName: bookingData['customer_name'],
              bookingDate: DateTime.parse(bookingData['booking_date']),
              timeSlot: bookingData['time_slot'],
              totalPrice: int.parse(bookingData['total_price'].toString()),
              paymentMethod: bookingData['payment_method'],
              status: bookingData['status'],
              createdAt: DateTime.parse(bookingData['created_at']),
              items: (bookingData['items'] as List).map((item) {
                final serviceData = item['service'];
                return BookingItem(
                  service: Service(
                    id: int.parse(serviceData['id'].toString()),
                    name: serviceData['name'],
                    price: int.parse(serviceData['price'].toString()),
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
              }).toList(),
            );
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print("❌ Error getBookings: $e");
      return [];
    }
  }

  // ✅ Buat booking baru
  static Future<bool> createBooking({
    required int userId,
    required Booking booking,
  }) async {
    try {
      // Convert items ke JSON
      final itemsJson = booking.items.map((item) => {
        'service_id': item.service.id,
        'quantity': item.quantity,
        'price': item.service.price,
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/bookings.php'),
        body: {
          'user_id': userId.toString(),
          'booking_id': booking.id,
          'customer_name': booking.customerName,
          'booking_date': '${booking.bookingDate.year}-${booking.bookingDate.month.toString().padLeft(2, '0')}-${booking.bookingDate.day.toString().padLeft(2, '0')}',
          'time_slot': booking.timeSlot,
          'total_price': booking.totalPrice.toString(),
          'payment_method': booking.paymentMethod,
          'status': booking.status,
          'items': jsonEncode(itemsJson),
        },
      );

      print("📡 Response create booking: ${response.body}");

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("❌ Error createBooking: $e");
      return false;
    }
  }
}
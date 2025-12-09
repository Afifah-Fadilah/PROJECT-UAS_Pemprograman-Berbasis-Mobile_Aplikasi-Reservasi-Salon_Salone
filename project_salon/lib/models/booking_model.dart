import 'package:project_salon/models/service_model.dart';

class BookingItem {
  final Service service;
  final int quantity;
  
  BookingItem({
    required this.service,
    required this.quantity,
  });
}

class Booking {
  final String id;
  final String customerName;
  final List<BookingItem> items;
  final DateTime bookingDate;
  final String timeSlot;
  final int totalPrice;
  final String paymentMethod;
  final DateTime createdAt;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'

  Booking({
    required this.id,
    required this.customerName,
    required this.items,
    required this.bookingDate,
    required this.timeSlot,
    required this.totalPrice,
    required this.paymentMethod,
    required this.createdAt,
    this.status = 'confirmed',
  });
}
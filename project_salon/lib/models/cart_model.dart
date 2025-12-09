import 'package:project_salon/models/service_model.dart';

class CartItem {
  final Service service;
  int quantity;

  CartItem({
    required this.service,
    required this.quantity,
  });
}
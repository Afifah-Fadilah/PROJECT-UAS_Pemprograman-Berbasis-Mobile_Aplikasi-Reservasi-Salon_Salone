import 'package:flutter/material.dart';
import 'package:project_salon/screens/booking/history_page.dart';
import 'package:project_salon/screens/cart/keranjang_page.dart';
import 'package:project_salon/screens/favorite/favorite_page.dart';
import 'package:project_salon/screens/home/home_page.dart';
import 'package:project_salon/screens/profile/profile_page.dart';
import 'package:project_salon/models/service_model.dart';
import 'package:project_salon/models/cart_model.dart';
import 'package:project_salon/models/booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_salon/services/favorite.dart';
import 'package:project_salon/services/cart.dart';
import 'package:project_salon/services/bookings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<CartItem> _cart = [];
  List<Service> _favoriteServices = [];
  List<Booking> _bookingHistory = []; // ✅ TAMBAH INI
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // ✅ Load user ID & favorites
  }

  // ✅ LOAD USER DATA & FAVORITES
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id') ?? 0;

    if (_userId > 0) {
      await _loadFavorites();
      await _loadCart();
      await _loadBookings();
    }
  }

  // ✅ LOAD FAVORITES DARI API
  Future<void> _loadFavorites() async {
    final favorites = await FavoriteService.getFavorites(_userId);
    setState(() {
      _favoriteServices = favorites;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ LOAD CART DARI API
  Future<void> _loadCart() async {
    final cartItems = await CartService.getCart(_userId);
    setState(() {
      _cart = cartItems;
    });
    print("🛒 Cart loaded: ${_cart.length} items"); // ✅ DEBUG
  }

  // ✅ LOAD BOOKINGS DARI API
  Future<void> _loadBookings() async {
    final bookings = await BookingService.getBookings(_userId);
    setState(() {
      _bookingHistory = bookings;
    });
    print("📅 Bookings loaded: ${_bookingHistory.length} items");
  }

  // ✅ ADD TO CART - SIMPAN KE DATABASE
  Future<void> _addToCart(Service service, int quantity) async {
    final success = await CartService.addToCart(_userId, service.id, quantity);

    if (success) {
      await _loadCart(); // Reload cart dari database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${service.name} ditambahkan ke keranjang'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ✅ UPDATE QUANTITY - SIMPAN KE DATABASE
  Future<void> _updateCartQuantity(int serviceId, int newQuantity) async {
    final success =
        await CartService.updateQuantity(_userId, serviceId, newQuantity);

    if (success) {
      await _loadCart(); // Reload cart dari database
    }
  }

  // ✅ UBAH TOGGLE FAVORITE - SIMPAN KE DATABASE
  Future<void> _onToggleFavorite(Service service) async {
    final isFavorite = _favoriteServices.any((s) => s.id == service.id);

    if (isFavorite) {
      // Hapus dari favorit
      final success = await FavoriteService.removeFavorite(_userId, service.id);
      if (success) {
        setState(() {
          _favoriteServices.removeWhere((s) => s.id == service.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.name} dihapus dari favorit'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey.shade700,
          ),
        );
      }
    } else {
      // Tambah ke favorit
      final success = await FavoriteService.addFavorite(_userId, service.id);
      if (success) {
        setState(() {
          _favoriteServices.add(service);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${service.name} ditambahkan ke favorit'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.pink,
          ),
        );
      }
    }
  }

  // ✅ BOOKING COMPLETE - SIMPAN KE DATABASE
  Future<void> _onBookingComplete(Booking booking) async {
    // Simpan booking ke database
    final success = await BookingService.createBooking(
      userId: _userId,
      booking: booking,
    );

    if (success) {
      // Kosongkan cart di database
      await CartService.clearCart(_userId);

      // Reload bookings dan cart
      await _loadBookings();
      await _loadCart();

      setState(() {
        _selectedIndex = 3; // Pindah ke halaman history
      });

      print("✅ Booking berhasil disimpan!");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(
          cart: _cart,
          onAddToCart: _addToCart,
          favoriteServices: _favoriteServices,
          onToggleFavorite: _onToggleFavorite,
        );
      case 1:
        return FavoritPage(
          favoriteServices: _favoriteServices,
          onToggleFavorite: _onToggleFavorite,
        );
      case 2:
        return KeranjangPage(
          cart: _cart,
          onUpdateQuantity: _updateCartQuantity,
          onBookingComplete: _onBookingComplete, // ✅ TAMBAH INI
        );
      case 3:
        return HistoryPage(bookings: _bookingHistory); // ✅ UBAH INI
      case 4:
        return const ProfilePage();
      default:
        return HomePage(
          cart: _cart,
          onAddToCart: _addToCart,
          favoriteServices: _favoriteServices,
          onToggleFavorite: _onToggleFavorite,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Beranda'),
                _buildNavItem(1, Icons.favorite_border, 'Favorit'),
                _buildNavItem(2, Icons.shopping_cart_outlined, 'Keranjang'),
                _buildNavItem(3, Icons.access_time, 'Histori'),
                _buildNavItem(4, Icons.person_outline, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.pink.shade600 : Colors.grey.shade400,
                  size: 24,
                ),

                // 🔴 Bulatan merah untuk FAVORIT
                if (index == 1 && _favoriteServices.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '${_favoriteServices.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // 🔴 Bulatan merah untuk KERANJANG
                if (index == 2 && _cart.isNotEmpty)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          '${_cart.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.pink.shade600 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

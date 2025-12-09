import 'package:flutter/material.dart';
import 'dart:async';
import 'package:project_salon/models/service_model.dart';
import 'package:project_salon/models/cart_model.dart';
import 'package:project_salon/models/promo_model.dart';
import 'package:project_salon/models/category_model.dart';
// ignore: unused_import
import 'package:project_salon/screens/favorite/favorite_page.dart';
import 'package:project_salon/screens/home/service_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_salon/services/services.dart';

class HomePage extends StatefulWidget {
  final List<CartItem> cart;
  final Function(Service, int) onAddToCart;
  final List<Service> favoriteServices;
  final Function(Service) onToggleFavorite;

  const HomePage({
    Key? key,
    required this.cart,
    required this.onAddToCart,
    required this.favoriteServices,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPromo = 0;
  Timer? _promoTimer;
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String userName = "";
  List<Service> services = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _promoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentPromo = (_currentPromo + 1) % promos.length;
      });
    });
    _loadUserName(); // ambil nama user saat halaman dibuka
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      final data = await ServicesService.fetchServices();
      print(
          "✅ Data services berhasil di-fetch: ${data.length} items"); // ✅ CEK INI
      print(
          "📦 Data pertama: ${data.isNotEmpty ? data[0].name : 'Kosong'}"); // ✅ CEK INI

      setState(() {
        services = data;
        loading = false;
      });
    } catch (e) {
      print("❌ Error: $e"); // ✅ CEK INI
      setState(() => loading = false);
    }
  }

  // Fungsi ambil nama user dari SharedPreferences
  _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name") ?? "User";
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    super.dispose();
  }

  List<Service> get _filteredServices {
    return services.where((service) {
      final matchesSearch =
          service.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'all' || service.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Service> get _bestSellers {
    return _filteredServices.where((s) => s.isBestSeller).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // penting biar notif tet
                children: [
                  // Bagian kiri: Sapaan
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang, $userName!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Saatnya bersinar dengan gaya barumu ✨',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Kanan: Icon notifikasi
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Colors.pink[400],
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 92, 92, 92)
                                .withOpacity(0.3),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari layanan...',
                          prefixIcon:
                              Icon(Icons.search, color: Colors.pink[400]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Promo Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SizedBox(
                      height: 160,
                      child: Stack(
                        children: [
                          ...List.generate(promos.length, (index) {
                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              left: (index - _currentPromo) *
                                  MediaQuery.of(context).size.width,
                              right: -(index - _currentPromo) *
                                  MediaQuery.of(context).size.width,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    promos[index]
                                        .imagePath, // ← pakai image dari list promos
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            );
                          }),
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(promos.length, (index) {
                                return Container(
                                  width: index == _currentPromo ? 24 : 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: index == _currentPromo
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Categories
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildCategoryItem(
                            'all', 'assets/icons/favorites.png', 'Semua'),
                        ...categories.map((cat) => _buildCategoryItem(
                            cat.name, cat.imagePath, cat.name)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Best Sellers
                  // Best Sellers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Layanan Terlaris',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ✅ TAMBAHKAN CEK LOADING & DATA KOSONG
                        if (loading)
                          Center(
                            child:
                                CircularProgressIndicator(color: Colors.pink),
                          )
                        else if (_bestSellers.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(Icons.inbox,
                                      size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'Tidak ada layanan terlaris',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _bestSellers.length,
                            itemBuilder: (context, index) {
                              final service = _bestSellers[index];
                              return ServiceCard(
                                service: service,
                                isFavorite: widget.favoriteServices
                                    .any((s) => s.id == service.id),
                                onToggleFavorite: () {
                                  widget.onToggleFavorite(service);
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServiceDetailPage(
                                        service: service,
                                        onAddToCart: widget.onAddToCart,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String category, String imagePath, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Image.asset(
                imagePath,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    service.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onToggleFavorite,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${service.rating} (${service.reviews})'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Rp ${service.price.toString()}',
                    style: const TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

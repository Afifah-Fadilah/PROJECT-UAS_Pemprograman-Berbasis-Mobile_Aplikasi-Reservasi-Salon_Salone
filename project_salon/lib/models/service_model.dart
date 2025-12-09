class Service {
  final int id;
  final String name;
  final int price;
  final double rating;
  final int reviews;
  final String category;
  final String image;
  final String description;
  final String duration;
  final bool isBestSeller;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.image,
    required this.description,
    required this.duration,
    required this.isBestSeller,
  });

  // ✅ TAMBAHKAN INI (opsional, tapi bagus untuk debugging)
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      price: int.parse(json['price'].toString().split('.')[0]),
      rating: double.parse(json['rating'].toString()),
      reviews: int.parse(json['reviews'].toString()),
      category: json['category'],
      image: json['image'],
      description: json['description'],
      duration: json['duration'],
      isBestSeller: json['is_best_seller'] == "1",
    );
  }

  // factory Service.fromJson(Map<String, dynamic> json) {
  //   return Service(
  //     id: json['id'],
  //     name: json['name'],
  //     imageUrl: json['image'],
  //     price: json['price'],
  //     duration: json['duration'],
  //     category: json['category'],
  //     description: json['description'],
  //     rating: json['rating'].toDouble(),
  //     reviews: json['reviews'],
  //     isBestSeller: json['is_best_seller'],
  //   );
  // }
}

// // Data dummy services
// final List<Service> services = [
//   Service(
//     id: 1,
//     name: 'Cat Rambut Premium',
//     price: 350000,
//     rating: 4.8,
//     reviews: 124,
//     category: 'Hair',
//     // imageUrl: 'assets/images/haircolor.jpg',
//     imageUrl: 'assets/images/cat-rambut.avif',
//     description:
//         'Pewarnaan rambut premium dengan bahan berkualitas tinggi dan tahan lama. Dilakukan oleh profesional berpengalaman.',
//     duration: '2-3 jam',
//     isBestSeller: true,
//   ),
//   Service(
//     id: 2,
//     name: 'Perawatan Kuku',
//     price: 150000,
//     rating: 4.9,
//     reviews: 200,
//     category: 'Nails',
//     imageUrl: 'assets/images/perawatan-kuku.jpg',
//     description:
//         'Perawatan lengkap untuk kuku tangan dan kaki dengan teknik profesional dan produk berkualitas.',
//     duration: '1-1.5 jam',
//     isBestSeller: true,
//   ),
//   Service(
//     id: 3,
//     name: 'Perawatan Spa Tubuh',
//     price: 500000,
//     rating: 4.7,
//     reviews: 89,
//     category: 'Spa',
//     imageUrl: 'assets/images/perawatan-spa.avif',
//     description:
//         'Relaksasi total dengan massage seluruh tubuh menggunakan essential oil pilihan.',
//     duration: '2 jam',
//     isBestSeller: true,
//   ),
//   Service(
//     id: 4,
//     name: 'Perawatan Wajah (Facial)',
//     price: 250000,
//     rating: 4.6,
//     reviews: 156,
//     category: 'Facial',
//     imageUrl: 'assets/images/perawatan-wajah.avif',
//     description:
//         'Perawatan wajah lengkap untuk membersihkan, menutrisi, dan meremajakan kulit wajah.',
//     duration: '1.5 jam',
//     isBestSeller: true,
//   ),
//   Service(
//     id: 5,
//     name: 'Smoothing Rambut',
//     price: 450000,
//     rating: 4.8,
//     reviews: 95,
//     category: 'Hair',
//     imageUrl: 'assets/images/smoothing-rambut.jpg',
//     description:
//         'Treatment untuk meluruskan rambut dengan hasil natural dan tahan lama.',
//     duration: '3-4 jam',
//     isBestSeller: true,
//   ),
//   Service(
//     id: 6,
//     name: 'Makeup Profesional',
//     price: 200000,
//     rating: 4.9,
//     reviews: 178,
//     category: 'Makeup',
//     // imageUrl: 'assets/images/haircolor.jpg',
//     imageUrl: 'assets/images/makeup-profesional.avif',
//     description:
//         'Layanan rias profesional untuk berbagai acara, mulai dari wisuda hingga pernikahan.',
//     duration: '1.5-2 jam',
//     isBestSeller: true,
//   ),
// ];

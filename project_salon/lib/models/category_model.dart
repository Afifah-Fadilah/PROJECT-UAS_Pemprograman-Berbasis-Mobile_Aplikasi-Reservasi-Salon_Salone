class Category {
  final int id;
  final String name;
  final String imagePath;

  Category({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}

// Data dummy categories
final List<Category> categories = [
  Category(id: 1, name: 'Rambut', imagePath: 'assets/icons/woman-hair.png'),
  Category(id: 2, name: 'Kuku', imagePath: 'assets/icons/manicure.png'),
  Category(id: 3, name: 'Spa', imagePath: 'assets/icons/massage.png'),
  Category(id: 4, name: 'Wajah', imagePath: 'assets/icons/facial-mask.png'),
  Category(id: 5, name: 'Makeup', imagePath: 'assets/icons/mascara.png'),
];

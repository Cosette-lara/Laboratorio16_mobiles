class Product {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String image;
  final String category;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    this.category = 'general',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
      category: json['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
  }
}

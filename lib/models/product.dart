class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final double price; // en RP por kg
  final String unit;
  final String description;
  final Map<String, String> attributes; // ej: Organic, Expiration, etc.

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.price,
    this.unit = "1kg",
    this.description = "",
    this.attributes = const {},
  });
}

final sampleProducts = <Product>[
  const Product(
    id: 'p1',
    name: 'Strawberry',
    imageUrl: 'assets/images/products/Strawberries.jpg',
    category: 'Fruit',
    price: 40,
    description:
        'Fresh strawberries, perfect for desserts. Sweet and 100% organic.',
    attributes: {'Organic': '100%', 'Reviews': '4.7 (120)'},
  ),
  const Product(
    id: 'p2',
    name: 'Lamb Meat',
    imageUrl: 'assets/images/products/lamb-meat.jpg',
    category: 'Meat',
    price: 450,
    description: 'Premium lamb meat. Tender, fresh, and protein-rich.',
    attributes: {'Protein': 'High', 'Reviews': '4.8 (56)'},
  ),
  const Product(
    id: 'p3',
    name: 'Red Chili Peppers',
    imageUrl: 'assets/images/products/rhcp.jpg',
    category: 'Vegetables',
    price: 35,
    description: 'Hot red chili peppers. Great for spicy dishes.',
    attributes: {'Spicy': '🔥🔥🔥', 'Organic': 'Yes', '100g': '80 kcal'},
  ),
  const Product(
    id: 'p4',
    name: 'Organic Carrots',
    imageUrl: 'assets/images/products/carrots.jpg',
    category: 'Vegetables',
    price: 25,
    description: 'Crunchy and fresh carrots, naturally sweet.',
    attributes: {'Organic': '100%', 'Vitamin A': 'High'},
  ),
];

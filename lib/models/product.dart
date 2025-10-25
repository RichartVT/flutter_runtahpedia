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
    imageUrl:
        'https://pixabay.com/get/g356559380dd68814e3fdd8e83c9f840883cc960aff06ebdc3b8b7e85c2a01aa49dc9ea7e543ba5675b99cc5271c773e58ecca33308689b1cd2310cbf7c8663f9_1280.jpg',
    category: 'Fruit',
    price: 40,
    description:
        'Fresh strawberries, perfect for desserts. Sweet and 100% organic.',
    attributes: {'Organic': '100%', 'Reviews': '4.7 (120)'},
  ),
  const Product(
    id: 'p2',
    name: 'Lamb Meat',
    imageUrl:
        'https://pixabay.com/get/g70b6577587ed1e2b811ef9fc9648c569d18bfa2a0a2ed8dbc5f40cb28fb1c81e13576b218a186c56e196c9a2df086c3222afb6476376b2d593e5e5d8ce466d9c_1280.jpg',
    category: 'Meat',
    price: 450,
    description: 'Premium lamb meat. Tender, fresh, and protein-rich.',
    attributes: {'Protein': 'High', 'Reviews': '4.8 (56)'},
  ),
  const Product(
    id: 'p3',
    name: 'Red Chili Peppers',
    imageUrl:
        'https://pixabay.com/get/g056355f7e5ac5cc8c63fd6c35dc34d4cf7b2baa2dbcc7c119132154e3fe078f66be1ea6266d4765873304b62d4c7754906a6dc5fabe104c487a13247df46cfe8_1280.jpg',
    category: 'Vegetables',
    price: 35,
    description: 'Hot red chili peppers. Great for spicy dishes.',
    attributes: {'Spicy': '🔥🔥🔥', 'Organic': 'Yes', '100g': '80 kcal'},
  ),
  const Product(
    id: 'p4',
    name: 'Organic Carrots',
    imageUrl:
        'https://pixabay.com/get/g01f507279bd6242cfca3f0f36899bbfa68cfb9af01ebe6c799d705a80e2945719303bc18497eb1fb3b545823c29f89a556565d1d7e2b39b4294df954b52f6893_1280.jpg',
    category: 'Vegetables',
    price: 25,
    description: 'Crunchy and fresh carrots, naturally sweet.',
    attributes: {'Organic': '100%', 'Vitamin A': 'High'},
  ),
  const Product(
    id: 'p5',
    name: 'Apples',
    imageUrl:
        'https://pixabay.com/get/g628f0cea9d049bf883ec1b62431efb1de77dcddf2b644c52cda543fb1187b61bb3a9dd67408a2bf2ccbfcca364047770a3d3cc0cf440f256e1455738de8701f4_1280.jpg',
    category: 'Fruit',
    price: 30,
    description: 'Crisp green and red apples. Refreshing and rich in fiber.',
    attributes: {'Organic': 'Yes', 'Calories': '52 kcal/100g'},
  ),
  const Product(
    id: 'p6',
    name: 'Avocado',
    imageUrl:
        'https://pixabay.com/get/g1230d6116f954600f050b72fdcfc0c2ba52804431681417e727601ba6e5fff5ea74f6949ee2f5e93c30b502c47581bc43b7e76ab65f61629d010e7d45ac07c83_1280.jpg',
    category: 'Fruit',
    price: 55,
    description:
        'Creamy avocado rich in healthy fats and vitamins. Perfect for salads.',
    attributes: {'Fat': 'Good fats', 'Fiber': 'High'},
  ),
  const Product(
    id: 'p7',
    name: 'Broccoli',
    imageUrl:
        'https://pixabay.com/get/gf477daff8860736a59d72580189e5329e2fc1808b64d4106c2a57a9d4858c3f4793500af9800ddb46674a5a62ed76454caeb2c30e77ee970f4505b0f5c469081_1280.jpg',
    category: 'Vegetables',
    price: 28,
    description:
        'Fresh broccoli florets. Packed with vitamins and antioxidants.',
    attributes: {'Vitamin C': 'High', 'Organic': 'Yes'},
  ),
  const Product(
    id: 'p8',
    name: 'Fresh Salmon',
    imageUrl:
        'https://pixabay.com/get/ge61d9fa2d434ecf7a1cadc54a86e4fa57f8b74b5181e1a3aae1ed0fc1c4604b28824117a1d71c52bc3f569bd403514f2bbc9127d580893daed79e9b8714e6628_1280.jpg',
    category: 'Seafood',
    price: 680,
    description: 'Norwegian salmon fillet, perfect for sushi and grill.',
    attributes: {'Omega-3': 'High', 'Protein': 'Excellent'},
  ),
];

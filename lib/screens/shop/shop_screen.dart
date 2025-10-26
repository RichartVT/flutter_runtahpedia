import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopScreen extends StatefulWidget {
  static const route = '/shop';
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email ?? 'User';

    final cart = context.watch<CartProvider>();

    // 🔍 Filtrar productos por categoría y búsqueda
    final filteredProducts = sampleProducts.where((p) {
      final matchesCategory =
          selectedCategory == 'All' ||
          p.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch = p.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $name 👋'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, CartScreen.route),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cart.count > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.count}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search goods',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => searchQuery = value),
          ),
          const SizedBox(height: 16),
          _promo(),
          const SizedBox(height: 16),
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _categories(),
          const SizedBox(height: 16),
          const Row(
            children: [
              Text(
                'Best selling',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          filteredProducts.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No products found'),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (_, i) {
                    final p = filteredProducts[i];
                    return ProductCard(
                      product: p,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ProductDetailScreen.route,
                          arguments: p, // <-- MUY IMPORTANTE
                        );
                      },
                      onAdd: () => context.read<CartProvider>().add(p),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _promo() => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 140,
      color: const Color(0xFFFDE2E2),
      padding: const EdgeInsets.all(20),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'New User Offers\nGet 5%',
              style: TextStyle(
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Icon(Icons.local_offer, size: 48),
        ],
      ),
    ),
  );

  Widget _categories() {
    final cats = [
      ('All', Icons.all_inclusive_outlined),
      ('Fruit', Icons.apple_outlined),
      ('Vegetables', Icons.eco_outlined),
      ('Diary', Icons.egg_outlined),
      ('Meat', Icons.set_meal_outlined),
      ('Seafood', Icons.sailing_outlined),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final c in cats)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => selectedCategory = c.$1),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: selectedCategory == c.$1
                          ? Colors.green
                          : const Color(0xFFEFF6EE),
                      child: Icon(
                        c.$2,
                        color: selectedCategory == c.$1
                            ? Colors.white
                            : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c.$1,
                      style: TextStyle(
                        fontWeight: selectedCategory == c.$1
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: selectedCategory == c.$1
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

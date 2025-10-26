import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'checkout_success_screen.dart';

class CartScreen extends StatelessWidget {
  static const route = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: _pickupCard(),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(height: 24),
              itemBuilder: (_, i) {
                final it = cart.items[i];
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(it.imageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '1kg, ${it.price.toStringAsFixed(0)}MXN',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    _qtyButton(
                      context,
                      icon: Icons.remove,
                      onTap: () =>
                          context.read<CartProvider>().decrement(it.productId),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${it.qty}'),
                    ),
                    _qtyButton(
                      context,
                      icon: Icons.add,
                      onTap: () =>
                          context.read<CartProvider>().increment(it.productId),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty
                    ? null
                    : () {
                        final total = cart.total;
                        Navigator.pushNamed(
                          context,
                          CheckoutSuccessScreen.route,
                          arguments: total,
                        );
                      },

                child: const Text('Checkout'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickupCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: const Color(0xFFF0F5F1),
        padding: const EdgeInsets.all(14),
        child: const Row(
          children: [
            Icon(Icons.location_on_outlined),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pickup Point:\nKantor Desa Demangharjo',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(Icons.map_outlined),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFF0F3F1),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }
}

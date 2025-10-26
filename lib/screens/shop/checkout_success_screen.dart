import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../database/purchase_database.dart';
import '../../models/purchase.dart';
import '../../providers/cart_provider.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  static const route = '/checkout-success';
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double totalArg =
        (ModalRoute.of(context)!.settings.arguments as double?) ?? 0;
    final now = DateTime.now();
    final code =
        'S-${Random().nextInt(900) + 100} ${Random().nextInt(900) + 100}';

    // Aplicamos tu descuento de -10 de forma segura

    final cartTotal = context.read<CartProvider>().total;
    final double grandTotal =
        (((totalArg > 0 ? totalArg : cartTotal) - 10).clamp(0, 1e9)).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Check Out')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 12),
          const Center(
            child: CircleAvatar(
              radius: 54,
              backgroundColor: Color(0xFFE6F4EA),
              child: Icon(Icons.check, size: 56, color: Colors.green),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Transaction Success',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              DateFormat('d MMMM yyyy • HH:mm').format(now),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Unique Code', textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            code,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.white],
                stops: [0.0, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          _row(
            'Total',
            '${totalArg.toStringAsFixed(0)} MXN',
            valueStyle: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
          _row(
            'Discount',
            '-10 MXN',
            valueStyle: const TextStyle(color: Colors.red),
          ),
          _row(
            'Grand Total',
            '${grandTotal.toStringAsFixed(0)} MXN',
            valueStyle: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Share Transaction'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // 🧾 Guardar en SQLite usando datos reales del carrito
                    final ok = await _savePurchaseFromCart(
                      context: context,
                      grandTotal: grandTotal,
                    );

                    if (!context.mounted) return;

                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Purchase saved successfully 🧾'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      // Vuelve a la raíz (AppBottomNav)
                      Navigator.popUntil(context, (r) => r.isFirst);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cart is empty. Nothing to save in history.',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text('Save to History'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Intenta leer el carrito desde el provider y genera:
  Future<bool> _savePurchaseFromCart({
    required BuildContext context,
    required double grandTotal,
  }) async {
    final cart = context.read<CartProvider>();

    // Si no hay nada en el carrito, nos salimos
    final items = cart.items; // List<CartItem>
    if (items.isEmpty) return false;

    // Cantidad total (suma de qty)
    final int quantity = items.fold<int>(0, (sum, it) => sum + it.qty);

    // Serializamos para guardarlo en 'items' (string)
    final itemsList = items.map((it) {
      return {
        'productId': it.productId,
        'name': it.name,
        'qty': it.qty,
        'price': it.price,
        'subtotal': (it.price * it.qty),
        'imageUrl': it.imageUrl,
      };
    }).toList();
    final String itemsString = jsonEncode(itemsList);

    // Fecha como TEXT
    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    // Si por cualquier motivo grandTotal llega 0, usa el total real del carrito
    final double totalToSave = grandTotal > 0 ? grandTotal : cart.total;

    await PurchaseDatabase.instance.insertPurchase(
      Purchase(
        date: formattedDate,
        total: totalToSave,
        quantity: quantity,
        items: itemsString,
      ),
    );

    // Limpia carrito
    cart.clear();
    return true;
  }

  Widget _row(String k, String v, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(k),
          const Spacer(),
          Text(v, style: valueStyle),
        ],
      ),
    );
  }
}

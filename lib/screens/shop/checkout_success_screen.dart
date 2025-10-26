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
    final double grandTotal = ((totalArg - 10).clamp(0, 1e9)).toDouble(); // MXN

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
  /// - quantity total
  /// - items (JSON si es posible; texto si no)
  /// Luego inserta en SQLite y limpia el carrito.
  Future<bool> _savePurchaseFromCart({
    required BuildContext context,
    required double grandTotal,
  }) async {
    final cart = context.read<CartProvider>();

    // 1) Obtener cantidad total
    int quantity = 0;
    try {
      // Si el provider expone 'count' (como usaste en el badge)
      quantity = cart.count;
    } catch (_) {
      // fallback: intenta sumar desde items si es un Map<Product,int>
      try {
        final dynamic items = cart.items;
        if (items is Map) {
          quantity = items.values.fold<int>(0, (a, b) => a + (b as int));
        }
      } catch (_) {}
    }

    if (quantity <= 0) return false;

    // 2) Intentar construir JSON de items (name, qty, price)
    String itemsString = 'Various products';
    try {
      final dynamic raw = cart.items;

      if (raw is Map) {
        // caso más común: Map<Product, int>
        final list = raw.entries.map((e) {
          final p = e.key; // Product
          final q = e.value; // int
          final id = (p as dynamic).id ?? '';
          final name = (p as dynamic).name ?? '';
          final price = ((p as dynamic).price as num?)?.toDouble() ?? 0.0;
          return {'id': id, 'name': name, 'qty': q, 'price': price};
        }).toList();
        itemsString = jsonEncode(list);
      } else if (raw is Iterable) {
        // otro caso: lista de CartLine con product y qty
        final list = raw.map((it) {
          final product = (it as dynamic).product;
          final qty = (it as dynamic).qty ?? 1;
          final id = (product as dynamic).id ?? '';
          final name = (product as dynamic).name ?? '';
          final price = ((product as dynamic).price as num?)?.toDouble() ?? 0.0;
          return {'id': id, 'name': name, 'qty': qty, 'price': price};
        }).toList();
        itemsString = jsonEncode(list);
      } else {
        // último recurso: nombres separados por coma si existe 'items'
        try {
          itemsString = (raw as Iterable)
              .map((e) => (e as dynamic).product.name)
              .join(', ');
        } catch (_) {}
      }
    } catch (_) {
      // deja itemsString como 'Various products'
    }

    // 3) Fecha en formato simple (BD actual la espera como TEXT simple)
    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());

    // 4) Insertar en SQLite
    await PurchaseDatabase.instance.insertPurchase(
      Purchase(
        date: formattedDate,
        total: grandTotal,
        quantity: quantity,
        items: itemsString,
      ),
    );

    // 5) Limpiar carrito (si tu provider lo soporta)
    try {
      cart.clear();
    } catch (_) {}

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

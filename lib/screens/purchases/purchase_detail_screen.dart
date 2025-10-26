import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/purchase.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Purchase purchase;
  const PurchaseDetailScreen({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    // 🔍 Decodifica los productos guardados como JSON en la BD
    final List<dynamic> decoded = jsonDecode(purchase.items);
    final List<Map<String, dynamic>> products = decoded
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _summary(purchase),
          const SizedBox(height: 20),
          Text(
            'Products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),

          // ✅ Lista de productos reales
          ...products.map(
            (p) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              color: const Color(0xFFF5F7F6),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      p['imageUrl'] != null &&
                          p['imageUrl'].toString().isNotEmpty
                      ? AssetImage(p['imageUrl'])
                      : const AssetImage('assets/images/products/rhcp.jpg'),
                ),
                title: Text(
                  p['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'x${p['qty']}  •  ${p['price']} MXN',
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: Text(
                  '${p['subtotal']} MXN',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 40),

          // 🧾 Total final
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Grand Total: ${purchase.total.toStringAsFixed(2)} MXN',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(Purchase p) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Order ID', '#${p.id ?? '-'}'),
          _row('Date', p.date),
          _row('Items', p.quantity.toString()),
          _row('Total paid', '${p.total.toStringAsFixed(2)} MXN'),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}

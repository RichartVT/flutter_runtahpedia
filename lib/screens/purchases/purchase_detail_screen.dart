// TODO Implement this library.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/purchase.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Purchase purchase;
  const PurchaseDetailScreen({super.key, required this.purchase});

  List<_ParsedItem> _parseItems(String raw) {
    // Espera JSON tipo:
    // [{"name":"Strawberry","qty":2,"price":40.0}, ...]
    // Fallback: si no es JSON, devuelve una sola linea con el texto
    try {
      final decoded = json.decode(raw);
      if (decoded is List) {
        return decoded.map<_ParsedItem>((e) {
          final name = (e['name'] ?? '').toString();
          final qty = int.tryParse(e['qty']?.toString() ?? '') ?? 1;
          final price = double.tryParse(e['price']?.toString() ?? '') ?? 0.0;
          return _ParsedItem(name: name, qty: qty, price: price);
        }).toList();
      }
    } catch (_) {
      // ignore
    }
    // Fallback: items como texto plano
    if (raw.trim().isEmpty) return [];
    return [_ParsedItem(name: raw.trim(), qty: purchase.quantity, price: 0.0)];
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(purchase.date);
    final items = _parseItems(purchase.items);
    final currency = NumberFormat.currency(symbol: 'MXN ', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            context,
            title: 'Summary',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Order ID', '#${purchase.id ?? '-'}'),
                _kv('Date', date),
                _kv('Items', '${purchase.quantity}'),
                _kv('Total paid', currency.format(purchase.total)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(
            context,
            title: 'Products',
            child: items.isEmpty
                ? const Text('No product details available.')
                : Column(
                    children: [
                      for (final it in items) _itemRow(it, currency),
                      const Divider(height: 24),
                      _kv(
                        'Grand Total',
                        currency.format(
                          items.isNotEmpty
                              ? items.fold<double>(
                                  0.0,
                                  (sum, e) => sum + e.qty * e.price,
                                )
                              : purchase.total,
                        ),
                        valueStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String ymd) {
    try {
      final d = DateTime.parse(ymd);
      return DateFormat('d MMM yyyy • HH:mm').format(d);
    } catch (_) {
      return ymd;
    }
  }

  Widget _itemRow(_ParsedItem it, NumberFormat currency) {
    final line = it.qty * it.price;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              it.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text('x${it.qty}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Text(
            currency.format(it.price),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Text(
            currency.format(line),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(k)),
          Text(v, style: valueStyle),
        ],
      ),
    );
  }
}

class _ParsedItem {
  final String name;
  final int qty;
  final double price;

  _ParsedItem({required this.name, required this.qty, required this.price});
}

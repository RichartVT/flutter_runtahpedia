import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  static const route = '/checkout-success';
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double total =
        (ModalRoute.of(context)!.settings.arguments as double?) ?? 0;
    final now = DateTime.now();
    final code =
        'S-${Random().nextInt(900) + 100} ${Random().nextInt(900) + 100}';

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
            child: Text('Transaction Success',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
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
          Text(code,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
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
          _row('Total', '${total.toStringAsFixed(0)}RP',
              valueStyle: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.w700)),
          _row('Discount', '-10RP',
              valueStyle: const TextStyle(color: Colors.red)),
          _row('Grand Total',
              '${(total - 10).clamp(0, 1e9).toStringAsFixed(0)}RP',
              valueStyle: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.w800)),
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
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Save to Gallery'),
                ),
              ),
            ],
          )
        ],
      ),
    );
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

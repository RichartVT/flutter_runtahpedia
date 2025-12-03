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

  static const Color _primaryGreen = Color(0xFF48C178);
  static const Color _lightBackground = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final double totalArg = args['total'] ?? 0.0;
    final String pickupDateStr = args['pickupDate'] ?? '';

    final now = DateTime.now();
    final code =
        'S-${Random().nextInt(900) + 100} ${Random().nextInt(900) + 100}';

    final cartTotal = context.read<CartProvider>().total;
    final double grandTotal =
        (((totalArg > 0 ? totalArg : cartTotal) - 10).clamp(0, 1e9)).toDouble();

    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        title: const Text(
          'Check Out',
          style: TextStyle(
            color: _primaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono grande de success con círculos
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primaryGreen.withOpacity(0.16),
                        ),
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primaryGreen.withOpacity(0.24),
                        ),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primaryGreen,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título y fecha
              const Center(
                child: Text(
                  'Transaction Success',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  DateFormat('d MMMM yyyy • HH:mm').format(now),
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Unique Code
              const Text(
                'Unique Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // “Barcode” estilizado
              Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black,
                      Colors.white,
                      Colors.black,
                      Colors.white,
                      Colors.black,
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    tileMode: TileMode.mirror,
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    code.replaceAll(' ', ''),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 32),

              // Totales
              _row(
                'Total',
                '${totalArg.toStringAsFixed(0)} MXN',
                valueStyle: const TextStyle(
                  color: _primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _row(
                'Discount',
                '-10 MXN',
                valueStyle: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              _row(
                'Grand Total',
                '${grandTotal.toStringAsFixed(0)} MXN',
                valueStyle: const TextStyle(
                  color: _primaryGreen,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),
              const Divider(height: 32),

              // Info extra (pickup date)
              if (pickupDateStr.isNotEmpty) ...[
                const Text(
                  'Pickup Date',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pickupDateStr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          color: _primaryGreen.withOpacity(0.8),
                          width: 1.4,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Share Transaction',
                        style: TextStyle(
                          color: _primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final ok = await _savePurchaseFromCart(
                          context: context,
                          grandTotal: grandTotal,
                          pickupDateStr: pickupDateStr,
                        );

                        if (!context.mounted) return;

                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Purchase saved successfully 🧾'),
                              duration: Duration(seconds: 2),
                            ),
                          );
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
                      child: const Text(
                        'Save to History',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _savePurchaseFromCart({
    required BuildContext context,
    required double grandTotal,
    required String pickupDateStr,
  }) async {
    final cart = context.read<CartProvider>();
    final items = cart.items;
    if (items.isEmpty) return false;

    final int quantity = items.fold<int>(0, (sum, it) => sum + it.qty);

    final itemsList = {
      'products': items.map((it) {
        return {
          'productId': it.productId,
          'name': it.name,
          'qty': it.qty,
          'price': it.price,
          'subtotal': (it.price * it.qty),
          'imageUrl': it.imageUrl,
        };
      }).toList(),
      'pickupDate': pickupDateStr,
    };

    final String itemsString = jsonEncode(itemsList);

    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());
    final double totalToSave = grandTotal > 0 ? grandTotal : cart.total;

    await PurchaseDatabase.instance.insertPurchase(
      Purchase(
        date: formattedDate,
        total: totalToSave,
        quantity: quantity,
        items: itemsString,
        pickupDate: pickupDateStr,
      ),
    );

    cart.clear();
    return true;
  }

  Widget _row(String k, String v, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(k, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const Spacer(),
          Text(
            v,
            style:
                valueStyle ??
                const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

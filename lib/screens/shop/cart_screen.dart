import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../providers/cart_provider.dart';
import 'checkout_success_screen.dart';

class CartScreen extends StatefulWidget {
  static const route = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color _primaryGreen = Color(0xFF48C178);
  static const Color _lightBackground = Color(0xFFF5F6FA);

  DateTime? _selectedPickupDate;

  // 👇 mismo helper que en ProductCard
  ImageProvider<Object> _getImageProvider(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else if (path.startsWith('/')) {
      return FileImage(File(path));
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: _lightBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        title: const Text(
          'Cart',
          style: TextStyle(
            color: _primaryGreen,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shield_outlined, color: _primaryGreen),
          ),
        ],
      ),
      body: Column(
        children: [
          // Card de “Pickup date” / calendario
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: _pickupCard(),
          ),

          // Lista de items
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 24, color: Colors.grey.shade300),
              itemBuilder: (_, i) {
                final it = cart.items[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      backgroundImage: _getImageProvider(it.imageUrl),
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
                          const SizedBox(height: 2),
                          Text(
                            '1kg, ${it.price.toStringAsFixed(0)} MXN',
                            style: const TextStyle(
                              color: _primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: () =>
                          context.read<CartProvider>().decrement(it.productId),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '${it.qty}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () =>
                          context.read<CartProvider>().increment(it.productId),
                    ),
                  ],
                );
              },
            ),
          ),

          // Botón de Checkout redondeado
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty || _selectedPickupDate == null
                    ? null
                    : () {
                        final total = cart.total;
                        final pickupDateStr = DateFormat(
                          'yyyy-MM-dd',
                        ).format(_selectedPickupDate!);

                        Navigator.pushNamed(
                          context,
                          CheckoutSuccessScreen.route,
                          arguments: {
                            'total': total,
                            'pickupDate': pickupDateStr,
                          },
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  disabledBackgroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 32,
                  ),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickupCard() {
    final today = DateTime.now();
    final firstDay = today.add(const Duration(days: 3));
    final lastDay = today.add(const Duration(days: 5));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pickup Date:',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: _primaryGreen,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select the date when you will pick up your items.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _selectedPickupDate ?? firstDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedPickupDate),
            onDaySelected: (selectedDay, _) {
              setState(() {
                _selectedPickupDate = selectedDay;
              });
            },
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarFormat: CalendarFormat.week,
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: _primaryGreen,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color(0x3348C178),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    final bool isAdd = icon == Icons.add;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isAdd ? _primaryGreen : Colors.white,
            border: Border.all(
              color: isAdd ? _primaryGreen : const Color(0xFFE5E7EB),
              width: 1.4,
            ),
            boxShadow: isAdd
                ? const [
                    BoxShadow(
                      color: Color(0x3348C178),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isAdd ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

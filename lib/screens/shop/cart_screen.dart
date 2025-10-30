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
  DateTime? _selectedPickupDate;

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
                      icon: Icons.remove,
                      onTap: () =>
                          context.read<CartProvider>().decrement(it.productId),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${it.qty}'),
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
          Padding(
            padding: const EdgeInsets.all(20),
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
                child: const Text('Checkout'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Select pickup date:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
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
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          calendarFormat: CalendarFormat.week,
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return CircleAvatar(
      backgroundColor: const Color(0xFFF0F3F1),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }
}

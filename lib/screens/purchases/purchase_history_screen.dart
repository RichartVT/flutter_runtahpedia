import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/purchase.dart';
import '../../database/purchase_database.dart';
import 'purchase_detail_screen.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  static const route = '/history';
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  late Future<List<Purchase>> _purchasesFuture;

  @override
  void initState() {
    super.initState();
    _loadPurchases();
  }

  Future<void> _loadPurchases() async {
    setState(() {
      _purchasesFuture = PurchaseDatabase.instance.getAllPurchases();
    });
  }

  Future<void> _deletePurchase(Purchase purchase) async {
    if (purchase.id == null) return;
    await PurchaseDatabase.instance.deletePurchase(purchase.id!);
    await _loadPurchases();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase #${purchase.id} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(String ymd) {
    DateTime d;
    try {
      d = DateTime.parse(ymd);
    } catch (_) {
      final parts = ymd.split('-');
      if (parts.length >= 3) {
        d = DateTime(
          int.tryParse(parts[0]) ?? DateTime.now().year,
          int.tryParse(parts[1]) ?? DateTime.now().month,
          int.tryParse(parts[2]) ?? DateTime.now().day,
        );
      } else {
        d = DateTime.now();
      }
    }
    return DateFormat('d MMM yyyy, HH:mm').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase History'),
        actions: [
          IconButton(
            tooltip: 'Clear all',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Clear history'),
                  content: const Text(
                    'This will remove all your purchases from this device. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await PurchaseDatabase.instance.clearAll();
                _loadPurchases();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All purchases cleared')),
                );
              }
            },
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPurchases,
        child: FutureBuilder<List<Purchase>>(
          future: _purchasesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }

            final purchases = snapshot.data ?? [];
            if (purchases.isEmpty) {
              return ListView(
                children: const [SizedBox(height: 140), _EmptyState()],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: purchases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final p = purchases[i];

                return Dismissible(
                  key: ValueKey(p.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Purchase'),
                        content: Text(
                          'Are you sure you want to delete purchase #${p.id}? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) => _deletePurchase(p),
                  child: _PurchaseCard(
                    purchase: p,
                    formattedDate: _formatDate(p.date),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PurchaseDetailScreen(purchase: p),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  final Purchase purchase;
  final String formattedDate;
  final VoidCallback onTap;

  const _PurchaseCard({
    required this.purchase,
    required this.formattedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalText = '${purchase.total.toStringAsFixed(0)} MXN';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFEFF6EE),
              child: const Icon(Icons.receipt_long, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${purchase.id ?? '-'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$formattedDate • ${purchase.quantity} items',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  totalText,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Icon(Icons.chevron_right, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.history, size: 96, color: Colors.grey.withOpacity(.4)),
        const SizedBox(height: 12),
        const Text(
          'No purchases yet',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          'Your purchase history will appear here.',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

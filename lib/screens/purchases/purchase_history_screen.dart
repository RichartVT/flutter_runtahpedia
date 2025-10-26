import 'package:flutter/material.dart';
import '../../database/purchase_database.dart';
import '../../models/purchase.dart';

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
    _purchasesFuture = PurchaseDatabase.instance.getAllPurchases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Purchase History')),
      body: FutureBuilder<List<Purchase>>(
        future: _purchasesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final purchases = snapshot.data!;
          if (purchases.isEmpty) {
            return const Center(
              child: Text(
                'You have no purchases yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: purchases.length,
            itemBuilder: (_, i) {
              final p = purchases[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text('Purchase on ${p.date}'),
                  subtitle: Text(p.items),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${p.quantity} items'),
                      Text(
                        '\$${p.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key: productId
  DateTime? pickupDate;

  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (sum, it) => sum + it.qty);

  int qtyOf(String productId) => _items[productId]?.qty ?? 0;

  double get total => _items.values.fold(0, (sum, item) => sum + item.subtotal);

  void add(Product p, {int qty = 1}) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.qty += qty;
    } else {
      _items[p.id] = CartItem(
        id: '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(999)}',
        productId: p.id,
        name: p.name,
        price: p.price,
        qty: qty,
        imageUrl: p.imageUrl,
      );
    }
    notifyListeners();
  }

  void increment(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.qty++;
      notifyListeners();
    }
  }

  void decrement(String productId) {
    if (!_items.containsKey(productId)) return;
    final item = _items[productId]!;
    if (item.qty > 1) {
      item.qty--;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void setPickupDate(DateTime date) {
    pickupDate = date;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/product.dart';

class ShopProvider with ChangeNotifier {
  final List<Product> _products = [...sampleProducts];

  List<Product> get products => List.unmodifiable(_products);

  void add(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void remove(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}

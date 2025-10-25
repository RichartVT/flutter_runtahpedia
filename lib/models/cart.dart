class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  int qty;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    required this.imageUrl,
  });

  double get subtotal => price * qty;
}

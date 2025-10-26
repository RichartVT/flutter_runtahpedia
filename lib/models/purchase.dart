class Purchase {
  final int? id;
  final String date; // formato simple: YYYY-MM-DD
  final double total;
  final int quantity;
  final String items; // JSON string o nombres concatenados

  Purchase({
    this.id,
    required this.date,
    required this.total,
    required this.quantity,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'quantity': quantity,
      'items': items,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      date: map['date'],
      total: map['total'],
      quantity: map['quantity'],
      items: map['items'],
    );
  }
}

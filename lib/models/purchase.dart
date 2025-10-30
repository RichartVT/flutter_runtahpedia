class Purchase {
  final int? id;
  final String date;
  final double total;
  final int quantity;
  final String items;
  final String pickupDate;

  Purchase({
    this.id,
    required this.date,
    required this.total,
    required this.quantity,
    required this.items,
    this.pickupDate = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'quantity': quantity,
      'items': items,
      'pickupDate': pickupDate,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      date: map['date'],
      total: map['total'],
      quantity: map['quantity'],
      items: map['items'],
      pickupDate: map['pickupDate'] ?? '',
    );
  }
}

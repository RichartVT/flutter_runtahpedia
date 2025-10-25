class News {
  final String id;
  final String title;
  final String category;
  final String author;
  final String imageUrl;
  final String content;
  final DateTime date;

  News({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.imageUrl,
    required this.content,
    required this.date,
  });

  /// ✅ Comparación por ID (necesario para que `isSaved` y `toggleSaved` funcionen correctamente)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is News && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

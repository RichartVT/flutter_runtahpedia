import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 16 / 11,
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: Text(product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Text('${product.unit}, ${product.price.toStringAsFixed(0)}RP',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.green)),
                  const Spacer(),
                  if (onAdd != null)
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

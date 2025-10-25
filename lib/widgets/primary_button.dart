import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton(onPressed: onPressed, child: Text(label));
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
      child: Text(label),
    );
  }
}

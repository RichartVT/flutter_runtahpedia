import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  static const route = '/messages';
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Messages')));
  }
}

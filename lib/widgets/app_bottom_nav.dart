import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/purchases/purchase_history_screen.dart';
import '../screens/news/news_screen.dart';
import '../screens/shop/shop_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/account/account_screen.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatefulWidget {
  final int initialIndex;
  const AppBottomNav({super.key, this.initialIndex = 0});

  @override
  State<AppBottomNav> createState() => _AppBottomNavState();
}

class _AppBottomNavState extends State<AppBottomNav> {
  late int index;

  final pages = [
    NewsScreen(),
    ActivityPlaceholder(),
    ShopScreen(),
    PurchaseHistoryScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    index = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: kGreen,
        onPressed: () => setState(() => index = 2),
        child: const Icon(Icons.recycling, size: 36, color: Colors.white),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Purchases',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class ActivityPlaceholder extends StatelessWidget {
  const ActivityPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Activity'));
  }
}

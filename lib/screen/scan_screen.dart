import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widget/app_bottom_nav_bar.dart';
import '../widget/grocery_barcode_scanner.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton.filled(
          onPressed: () => context.goNamed('home'),
          icon: const Icon(Icons.home),
        ),
        title: const Text('Scan Products'),
        actions: [
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.abc),
          ),
          const SizedBox(width: 4.0),
        ],
      ),
      body: const GroceryBarcodeScanner(),
      bottomNavigationBar: const BottomNavBar(index: 2),
    );
  }
}

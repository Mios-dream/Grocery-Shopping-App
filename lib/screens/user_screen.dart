import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav_bar.dart';


class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
      ),
      body: const Center(child: Text('User Screen')),
      bottomNavigationBar: const AppBottomNavBar(index: 4),
    );
  }
}

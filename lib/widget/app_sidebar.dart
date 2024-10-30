import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: size.width * 0.7,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary,
            ),
            child: const Text(
              'GROCIFY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.goNamed('home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Browse'),
            onTap: () {
              context.goNamed('category', pathParameters: {'categoryID': '1'});
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Orders'),
            onTap: () {
              context.goNamed('order');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              context.goNamed('user');
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      width: size.width*0.5,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.inversePrimary,
            ),
            child: const Text(
              'Navigation',
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
              // 处理点击事件
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Browse'),
            onTap: () {
              // 处理点击事件

              context.goNamed('home');
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Orders'),
            onTap: () {
              // 处理点击事件
              context.goNamed('orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              // 处理点击事件
              context.goNamed('user');
            },
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48.0),
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          height: 80,
          selectedIndex: index,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (value) {
            switch (value) {
              case 0:
                context.goNamed('home');
                break;
              case 1:
                context
                    .goNamed('category', pathParameters: {'categoryID': '1'});
                break;
              case 2:
                context.goNamed('scan');
                break;
              case 3:
                context.goNamed('order');
                break;
              case 4:
                context.goNamed('user');
                break;
              default:
                context.goNamed('home');
            }
          },
          destinations: const <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 1),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.home, color: Colors.white),
                icon: Icon(Icons.home_outlined, color: Colors.white),
                label: 'Home',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.shopping_bag, color: Colors.white),
                icon: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                label: 'Browse',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.qr_code, color: Colors.white),
                icon: Icon(Icons.qr_code_2_outlined, color: Colors.white),
                label: 'Scan',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.history, color: Colors.white),
                icon: Icon(Icons.history_outlined, color: Colors.white),
                label: 'Orders',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: NavigationDestination(
                selectedIcon: Icon(Icons.person, color: Colors.white),
                icon: Icon(Icons.person_outline, color: Colors.white),
                label: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

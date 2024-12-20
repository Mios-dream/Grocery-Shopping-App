import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:model/model.dart';
import '../blocs/cart/cart_bloc.dart';
import 'grocery_search_text_form_field.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(112.0);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Cart? cart = context.watch<CartBloc>().state.cart;

    return AppBar(
      backgroundColor: colorScheme.primaryContainer,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu),
      ),
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Pickup',
            style: textTheme.bodySmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Location 1',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8.0),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Badge(
            isLabelVisible: cart?.cartItems.isEmpty ?? true ? false : true,
            label: Text(cart?.totalQuantity.toString() ?? ''),
            child: const Icon(Icons.shopping_basket),
          ),
          onPressed: () => context.pushNamed('cart'),
        ),
        const SizedBox(width: 8.0),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 12.0,
          ),
          child: Hero(
            tag: 'grocery_search_text_form_field',
            child: GrocerySearchTextFormField(
              onTap: () => context.pushNamed('search'),
            ),
          ),
        ),
      ),
    );
  }
}

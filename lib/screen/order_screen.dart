import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_shopping_app/blocs/orders/orders_bloc.dart';
import 'package:models/models.dart';

import '../blocs/cart/cart_bloc.dart';
import '../util/datetime_format.dart';
import '../widget/app_bottom_nav_bar.dart';
import '../widget/drawer.dart';
import '../widget/grocery_modal.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Cart? cart = context.watch<CartBloc>().state.cart;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const HomeDrawer(),
        appBar: AppBar(
          backgroundColor: colorScheme.primaryContainer,
          // 可以确保获取的上下文包含 Scaffold，以解决 context 丢失的问题
          leading: Builder(builder: (BuildContext innerContext) {
            return IconButton(
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
          centerTitle: true,
          title: Column(
            children: [
              Text('Pickup', style: textTheme.bodySmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Location 1',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => context.pushNamed('cart'),
              icon: Badge(
                isLabelVisible: cart?.cartItems.isEmpty ?? true ? false : true,
                label: Text(cart?.totalQuantity.toString() ?? ''),
                child: const Icon(Icons.shopping_basket),
              ),
            ),
            const SizedBox(width: 8.0),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56.0),
            child: TabBar(
              indicatorWeight: 3,
              labelStyle: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(child: Text('My Orders')),
                Tab(child: Text('In Progress')),
              ],
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              _PastOrders(),
              _PendingOrders(),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(index: 3),
      ),
    );
  }
}

class _PastOrders extends StatelessWidget {
  const _PastOrders();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // List<Order> sampleData=[];
    // List<Order>? orders=context.watch<OrdersBloc>().state.orders;

    return BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Past Orders',
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (context) {
                      return const GroceryModal(
                        children: [
                          Text('One'),
                          Text('Two'),
                        ],
                      );
                    },
                  );
                },
                icon: const RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.tune),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.orders == null ? 0 : state.orders?.length,
              itemBuilder: (context, index) {
                final order = state.orders![index];

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(100),
                    border: Border.all(color: colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 30.0,
                            color: colorScheme.primary.withAlpha(200),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.orderDate.toCustomDate()),
                              const SizedBox(height: 4.0),
                              Text(
                                'Picked up at ${order.deliveryAddress.street}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text('TOTAL: \$${order.totalAmount.toString()}')
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          ...order.products
                              .take(4)
                              .map((product) => Expanded(
                                    flex: 1,
                                    child: AspectRatio(aspectRatio: 1,child: Container(
                                      margin: const EdgeInsets.only(right: 4.0),
                                      child: Image.network(
                                        product.imageUrl,
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),)

                                  ))
                              .toList(),
                          const SizedBox(width: 4.0),
                          Text('+${order.products.length - 4} more'),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('Reorder'),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.pushNamed(
                                  'order-details',
                                  pathParameters: {'orderId': order.id},
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                              child: Text(
                                'View',
                                style: textTheme.titleMedium!.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _PendingOrders extends StatelessWidget {
  const _PendingOrders();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Orders',
              style: textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useSafeArea: true,
                  isScrollControlled: true,
                  builder: (context) {
                    return const GroceryModal(
                      children: [
                        Text('One'),
                        Text('Two'),
                      ],
                    );
                  },
                );
              },
              icon: const RotatedBox(
                quarterTurns: 1,
                child: Icon(Icons.tune),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

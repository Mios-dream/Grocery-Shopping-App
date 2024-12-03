import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:model/model.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/payment_order/payment_order_bloc.dart';
import '../widget/grocery_cart_list.dart';
import '../widget/grocery_loading_indicator.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    Cart? cart = context.watch<CartBloc>().state.cart;
    List<CartItem>? cartItems = context.watch<CartBloc>().state.cart?.cartItems;

    int totalQuantity = cart?.totalQuantity ?? 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        centerTitle: true,
        toolbarHeight: 80.0,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Grocery Cart',
            style: textTheme.headlineMedium,
          ),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.initial) {
            return const GroceryLoadingIndicator();
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$totalQuantity Items in the Cart',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ExpansionTile(
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  tilePadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  childrenPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  backgroundColor: colorScheme.primaryContainer,
                  collapsedBackgroundColor: colorScheme.primaryContainer,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: const Text('Substitutions: Substitute if unavailable'),
                  children: [
                    _buildSubstitutionOption(
                      context,
                      CartSubstitutionPreference.allowSubstitutions.name,
                      CartSubstitutionPreference.allowSubstitutions.description,
                      Icons.switch_left,
                    ),
                    const SizedBox(height: 8.0),
                    _buildSubstitutionOption(
                      context,
                      CartSubstitutionPreference.noSubstitutions.name,
                      CartSubstitutionPreference.noSubstitutions.description,
                      Icons.stop_circle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CART ITEMS',
                        style: textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      GroceryCartList(cartItems: cart?.cartItems),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const _CartBottomNavBar(),
    );
  }

  Row _buildSubstitutionOption(
    BuildContext context,
    String title,
    String description,
    IconData iconData,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Icon(iconData)],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(description),
            ],
          ),
        )
      ],
    );
  }
}

class _CartBottomNavBar extends StatelessWidget {
  const _CartBottomNavBar();

  @override
  Widget build(BuildContext context) {
    Cart? cart = context.watch<CartBloc>().state.cart;
    String orderId = "";
    return BottomAppBar(
      height: 104,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'USD ${context.watch<CartBloc>().state.cart?.totalPrice.toStringAsFixed(2) ?? 0.0}',
                // 'USD 0.0',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Add More'),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () {
                    if (cart == null) {
                      return;
                    }
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return BlocBuilder<PaymentOrderBloc,
                              PaymentOrderState>(builder: (context, state) {
                            if (state is PaymentOrderInitial) {
                              BlocProvider.of<PaymentOrderBloc>(context)
                                  .add(CreatePaymentOrderEvent(cart: cart));
                              return const AlertDialog(
                                title: Text('Checkout'),
                                content: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is PaymentOrderError) {
                              return AlertDialog(
                                title: const Text('Checkout'),
                                content: Container(
                                  child: const Text('Something went wrong'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => context.pop(),
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            } else if (state is PaymentOrderLoading) {
                              return const AlertDialog(
                                title: Text('Checkout'),
                                content: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else {
                              if (state is PaymentOrderLoaded) {
                                orderId = state.orderId;
                              }
                              return AlertDialog(
                                title: const Text('Checkout'),
                                content: Container(
                                  child: const Text(
                                      'Activating payment program, Please pay for the order.'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      BlocProvider.of<PaymentOrderBloc>(context)
                                          .add(CartClearEvent());
                                      context.pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BlocBuilder<PaymentOrderBloc,
                                                PaymentOrderState>(
                                              builder: (context, state) {
                                                if (state
                                                    is QueryPaymentOrderLoaded) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          'Checkout'),
                                                      content: Container(
                                                        child: const Text(
                                                            'Payment completed, please check the order status'),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                        PaymentOrderBloc>(
                                                                    context)
                                                                .add(
                                                                    CartClearEvent());
                                                            context
                                                                .read<
                                                                    CartBloc>()
                                                                .state
                                                                .cart
                                                                ?.cartItems
                                                                .clear();


                                                            Navigator.of(
                                                                    context)
                                                                .popUntil((route) =>
                                                                    route
                                                                        .settings
                                                                        .name ==
                                                                    'cart');
                                                          },
                                                          child: const Text("退出"),
                                                        )
                                                      ]);
                                                } else if (state
                                                    is QueryPaymentOrderLoading) {
                                                  return const AlertDialog(
                                                    title:
                                                        Text('Checkout'),
                                                    content: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                } else if (state
                                                    is QueryPaymentOrderError) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          'Checkout'),
                                                      content: Container(
                                                          child: const Text(
                                                              'Something went wrong')),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                        PaymentOrderBloc>(
                                                                    context)
                                                                .add(
                                                                    CartClearEvent());
                                                            context.pop();
                                                          },
                                                          child: const Text("退出"),
                                                        )
                                                      ]);
                                                } else {
                                                  BlocProvider.of<
                                                              PaymentOrderBloc>(
                                                          context)
                                                      .add(
                                                          QueryPaymentOrderEvent(
                                                              orderId:
                                                                  orderId));
                                                  return const AlertDialog(
                                                    title:
                                                        Text('Checkout'),
                                                    content: SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          });
                                    },
                                    child: const Text('Payment completed'),
                                  ),
                                ],
                              );
                            }
                          });
                        });
                  },
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

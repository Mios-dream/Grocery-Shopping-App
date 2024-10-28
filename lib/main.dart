import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_shopping_app/repo/cart_repo.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/orders/orders_bloc.dart';
import 'nav/app_router.dart';
import 'repo/category_repo.dart';
import 'repo/product_repo.dart';
import 'repo/order_repo.dart';
import 'service/api_client.dart';

void main() {
  // 此处换成api的ip地址
  const String baseUrl = 'http://10.203.15.9:8080';
  final ApiClient apiClient = ApiClient(baseUrl: baseUrl);
  final CategoryRepo categoryRepository =
      CategoryRepo(apiClient: apiClient);

  final ProductRepo productRepository =
      ProductRepo(apiClient: apiClient);

  final CartRepo cartRepository = CartRepo(apiClient: apiClient);

  final OrderRepo ordersRepository=OrderRepo(apiClient: apiClient);

  runApp(MyApp(
    categoryRepository: categoryRepository,
    productRepository: productRepository,
    cartRepository: cartRepository,
    orderRepository:  ordersRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.categoryRepository,
    required this.productRepository,
    required this.cartRepository,
    required this.orderRepository
  });

  final CategoryRepo categoryRepository;
  final ProductRepo productRepository;
  final CartRepo cartRepository;
  final OrderRepo orderRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: cartRepository),
        RepositoryProvider.value(value: orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              categoryRepository: context.read<CategoryRepo>(),
              productRepository: context.read<ProductRepo>(),
            )..add(const HomeLoadEvent()),
          ),
          BlocProvider<CartBloc>(
              create: (_) => CartBloc(cartRepository: cartRepository)),
          BlocProvider<OrdersBloc>(
            create: (_) => OrdersBloc(ordersRepository: orderRepository)..add(const OrdersLoadEvent()),
          ),

        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
            useMaterial3: true,
          ),
          routerConfig: AppRouter().router,
        ),
      ),
    );
  }
}

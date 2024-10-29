import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocify/repo/cart_repo.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/order/order_bloc.dart';
import 'router/app_router.dart';
import 'repo/category_repo.dart';
import 'repo/product_repo.dart';
import 'repo/order_repo.dart';
import 'service/api_client.dart';

void main() {
  // 此处换成api的ip地址
  const String baseUrl = 'http://10.0.2.2:8080';
  final ApiClient apiClient = ApiClient(baseUrl: baseUrl);
  final CategoryRepo categoryRepo = CategoryRepo(apiClient: apiClient);

  final ProductRepo productRepo = ProductRepo(apiClient: apiClient);

  final CartRepo cartRepo = CartRepo(apiClient: apiClient);

  final OrderRepo ordersRepo = OrderRepo(apiClient: apiClient);

  runApp(GrocifyApp(
    categoryRepo: categoryRepo,
    productRepo: productRepo,
    cartRepo: cartRepo,
    orderRepo: ordersRepo,
  ));
}

class GrocifyApp extends StatelessWidget {
  const GrocifyApp(
      {super.key,
      required this.categoryRepo,
      required this.productRepo,
      required this.cartRepo,
      required this.orderRepo});

  final CategoryRepo categoryRepo;
  final ProductRepo productRepo;
  final CartRepo cartRepo;
  final OrderRepo orderRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: categoryRepo),
        RepositoryProvider.value(value: productRepo),
        RepositoryProvider.value(value: cartRepo),
        RepositoryProvider.value(value: orderRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              categoryRepo: context.read<CategoryRepo>(),
              productRepo: context.read<ProductRepo>(),
            )..add(const HomeLoadEvent()),
          ),
          BlocProvider<CartBloc>(
              create: (_) => CartBloc(cartRepository: cartRepo)),
          BlocProvider<OrderBloc>(
            create: (_) => OrderBloc(orderRepo: orderRepo)
              ..add(const OrderLoadEvent()),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_shopping_app/repositories/cart_repository.dart';

import 'blocs/cart/cart_bloc.dart';

import 'blocs/home/home_bloc.dart';
import 'navigation/app_router.dart';
import 'repositories/category_repository.dart';
import 'repositories/product_repository.dart';
import 'services/api_client.dart';



void main() {
  // 此处换成api的ip地址
  const String baseUrl = 'http://10.203.15.9:8080';
  final ApiClient apiClient = ApiClient(baseUrl: baseUrl);
  final CategoryRepository categoryRepository =
      CategoryRepository(apiClient: apiClient);

  final ProductRepository productRepository =
      ProductRepository(apiClient: apiClient);

  final CartRepository cartRepository =
  CartRepository(apiClient: apiClient);

  runApp(MyApp(
    categoryRepository: categoryRepository,
    productRepository: productRepository,
    cartRepository: cartRepository,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.categoryRepository,
    required this.productRepository,
    required this.cartRepository,
  });

  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final CartRepository cartRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: categoryRepository),
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: cartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(
              categoryRepository: context.read<CategoryRepository>(),
              productRepository: context.read<ProductRepository>(),

            )..add(const HomeLoadEvent()),
          ),
          BlocProvider<CartBloc>(create: (_) => CartBloc(cartRepository: cartRepository)),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: AppRouter().router,
        ),
      ),
    );
  }
}

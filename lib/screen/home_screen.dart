import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:model/model.dart';

import '../blocs/home/home_bloc.dart';
import '../widget/app_top_bar.dart';
import '../widget/app_bottom_nav_bar.dart';
import '../widget/app_sidebar.dart';
import '../widget/grocery_loading_indicator.dart';
import '../widget/grocery_product_list.dart';
import '../widget/grocery_product_of_the_day.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TopBar(),
      drawer: const Sidebar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.initial ||
              state.status == HomeStatus.loading) {
            return const GroceryLoadingIndicator();
          }
          if (state.status == HomeStatus.loaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      textTheme,
                      'Popular Categories',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      height: 130.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.popularCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              context.goNamed(
                                'category',
                                pathParameters: {
                                  'categoryID':
                                      state.popularCategories[index].id,
                                },
                              );
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    state.popularCategories[index].imageUrl ??
                                        'https://via.placeholder.com/80',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  // Image.asset(
                                  //   'path/to/image',
                                  //   height: 80,
                                  //   width: 80,
                                  //   fit: BoxFit.cover,
                                  // ),

                                  const SizedBox(height: 8.0),
                                  Text(
                                    state.popularCategories[index].name,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    GroceryProductOfTheDay(
                      product: state.productOfTheDay ?? Product.empty,
                    ),
                    const SizedBox(height: 8.0),
                    _buildSectionTitle(
                      textTheme,
                      'Popular Products',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8.0),
                    GroceryProductList(products: state.popularProducts),
                    _buildSectionTitle(
                      textTheme,
                      'Featured Products',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8.0),
                    GroceryProductList(products: state.featuredProducts),
                  ],
                ),
              ),
            );
          } else {
            return const Text('Something went wrong');
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(index: 0),
    );
  }

  Row _buildSectionTitle(
    TextTheme textTheme,
    String title, {
    VoidCallback? onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}

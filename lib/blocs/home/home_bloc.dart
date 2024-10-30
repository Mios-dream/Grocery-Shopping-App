import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/model.dart';

import '../../repo/category_repo.dart';
import '../../repo/product_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CategoryRepo _categoryRepository;
  final ProductRepo _productRepository;

  HomeBloc({
    required CategoryRepo categoryRepo,
    required ProductRepo productRepo,
  })  : _categoryRepository = categoryRepo,
        _productRepository = productRepo,
        super(const HomeState()) {
    on<HomeLoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
    HomeLoadEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2));
      final categories = _categoryRepository.getCategories();
      final products = _productRepository.getProducts();

      final results = await Future.wait([categories, products]);

      emit(
        state.copyWith(
          status: HomeStatus.loaded,
          popularCategories: results[0] as List<Category>,
          popularProducts: results[1] as List<Product>,
          featuredProducts: results[1] as List<Product>,
          productOfTheDay: results[1].first as Product,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}

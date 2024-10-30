import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/model.dart';

import '../../repo/category_repo.dart';
import '../../repo/product_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepo _categoryRepository;
  final ProductRepo _productRepository;

  CategoryBloc({
    required CategoryRepo categoryRepo,
    required ProductRepo productRepo,
  })  : _categoryRepository = categoryRepo,
        _productRepository = productRepo,
        super(const CategoryState()) {
    on<CategoryLoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
    CategoryLoadEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 1));
      final categories = _categoryRepository.getCategoryById(event.categoryID);
      final products = _productRepository.getProductsByCategoryID(
        event.categoryID,
      );

      final results = await Future.wait([categories, products]);
      emit(
        state.copyWith(
          status: CategoryStatus.loaded,
          category: results[0] as Category,
          categoryProducts: results[1] as List<Product>,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CategoryStatus.error));
    }
  }
}

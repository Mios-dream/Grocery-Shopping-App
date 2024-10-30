part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryLoadEvent extends CategoryEvent {
  final String categoryID;

  const CategoryLoadEvent({required this.categoryID});

  @override
  List<Object> get props => [categoryID];
}

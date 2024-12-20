part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  final String userId;

  const LoadCart(this.userId);

  @override
  List<Object> get props => [userId];
}

class AddToCart extends CartEvent {
  final String userID;
  final Product product;

  const AddToCart({
    required this.userID,
    required this.product,
  });

  @override
  List<Object> get props => [product, userID];
}

class RemoveFromCart extends CartEvent {
  final String userId;
  final CartItem cartItem;

  const RemoveFromCart({
    required this.userId,
    required this.cartItem,
  });

  @override
  List<Object> get props => [cartItem, userId];
}

class ClearCart extends CartEvent {
  final String userId;
  const ClearCart({required this.userId});

  @override
  List<Object> get props => [];
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:model/model.dart';
import '../../repo/cart_repo.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo _cartRepository;

  CartBloc({
    required CartRepo cartRepository,
  })  : _cartRepository = cartRepository,
        super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      final cart = await _cartRepository.getCart(event.userId);

      emit(
        state.copyWith(
          status: CartStatus.loaded,
          cart: cart,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CartStatus.error));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      await _cartRepository.addToCart(event.userID, event.product);
      emit(state.copyWith(status: CartStatus.loaded));
      add(LoadCart(event.userID));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.error));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));

    try {
      await _cartRepository.removeFromCart(
        event.userId,
        event.cartItem.id,
      );

      emit(state.copyWith(status: CartStatus.loaded));
      add(LoadCart(event.userId));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.error));
    }
  }

  Future<void> _onClearCart(ClearCart event,
      Emitter<CartState> emit)async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      await _cartRepository.clearCart(event.userId);
      emit(state.copyWith(status: CartStatus.loaded));
      add(LoadCart(event.userId));
    } catch (_) {
      emit(state.copyWith(status: CartStatus.error));
    }
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:model/model.dart';

import '../../repo/order_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepo _orderRepository;

  OrderBloc({
    required OrderRepo orderRepo,
  })  : _orderRepository = orderRepo,
        super(const OrderState()) {
    on<OrderLoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
    OrderLoadEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    await Future.delayed(const Duration(seconds: 2));
    final orders = await _orderRepository.getOrders();
    try {
      emit(
        state.copyWith(
          status: OrderStatus.loaded,
          orders: orders,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error));
    }
  }
}

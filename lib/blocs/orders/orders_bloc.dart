import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../repo/order_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepo _orderRepository;

  OrdersBloc({
    required OrderRepo ordersRepository,
  })  : _orderRepository = ordersRepository,
        super(const OrdersState()) {
    on<OrdersLoadEvent>(_onLoadEvent);
  }

  Future<void> _onLoadEvent(
    OrdersLoadEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    print("加载订单");
    await Future.delayed(const Duration(seconds: 2));
    final orders = await _orderRepository.getOrders();
    try {


      emit(
        state.copyWith(
          status: OrdersStatus.loaded,
          orders: orders,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.error));
      print("order加载错误：$e");
    }
  }
}

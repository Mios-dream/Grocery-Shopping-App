part of 'orders_bloc.dart';

enum OrdersStatus { initial, loading, loaded, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order>? orders;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
      ];
}

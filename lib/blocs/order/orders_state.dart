part of 'order_bloc.dart';

enum OrderStatus { initial, loading, loaded, error }

class OrderState extends Equatable {
  final OrderStatus status;
  final List<Order>? orders;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<Order>? orders,
  }) {
    return OrderState(
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

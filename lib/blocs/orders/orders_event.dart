part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class OrdersLoadEvent extends OrdersEvent {
  const OrdersLoadEvent();

}

class OrdersRefreshEvent extends OrdersEvent {
  const OrdersRefreshEvent();
}


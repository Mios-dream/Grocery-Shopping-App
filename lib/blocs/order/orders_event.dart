part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderLoadEvent extends OrderEvent {
  const OrderLoadEvent();
}

class OrderRefreshEvent extends OrderEvent {
  const OrderRefreshEvent();
}

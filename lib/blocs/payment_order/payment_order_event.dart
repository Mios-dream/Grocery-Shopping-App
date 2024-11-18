part of 'payment_order_bloc.dart';


// 定义一个事件类
abstract class PaymentOrderEvent {}

class CreatePaymentOrderEvent extends PaymentOrderEvent {
  final Cart cart;
  CreatePaymentOrderEvent({required this.cart});
}

class QueryPaymentOrderEvent extends PaymentOrderEvent {
  final String orderId;
  QueryPaymentOrderEvent({required this.orderId});
}



class CartClearEvent extends PaymentOrderEvent {
  CartClearEvent();
}

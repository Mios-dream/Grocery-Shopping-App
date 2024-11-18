part of 'payment_order_bloc.dart';


// 定义一个状态类
abstract class PaymentOrderState {}

class PaymentOrderInitial extends PaymentOrderState {}


class PaymentOrderLoading extends PaymentOrderState {}

class PaymentOrderLoaded extends PaymentOrderState {
  final String orderId;

  PaymentOrderLoaded(this.orderId);
}

class PaymentOrderError extends PaymentOrderState {
  final String message;

  PaymentOrderError(this.message);
}

class QueryPaymentOrderInitial extends PaymentOrderState {}

class QueryPaymentOrderLoading extends PaymentOrderState {
  QueryPaymentOrderLoading();
}
class QueryPaymentOrderLoaded extends PaymentOrderState {
  final bool paymentState;

  QueryPaymentOrderLoaded(this.paymentState);
}

class QueryPaymentOrderError extends PaymentOrderState {
  final String message;

  QueryPaymentOrderError(this.message);
}



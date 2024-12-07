import 'package:bloc/bloc.dart';
import 'package:model/model.dart';

import '../../repo/order_repo.dart';

part 'payment_order_event.dart';
part 'payment_order_state.dart';

class PaymentOrderBloc extends Bloc<PaymentOrderEvent, PaymentOrderState> {
  final OrderRepo _orderRepository;

  PaymentOrderBloc({required OrderRepo orderRepo})
      : _orderRepository = orderRepo,
        super(PaymentOrderInitial()) {
    // 注册处理 CreatePaymentOrderEvent 的事件处理器
    on<CreatePaymentOrderEvent>(_createPaymentOrder);
    on<QueryPaymentOrderEvent>(_queryPaymentOrder);
    on<CartClearEvent>(_clearPaymentOrder);
  }

  // 事件处理器
  Future<void> _createPaymentOrder(CreatePaymentOrderEvent event, Emitter<PaymentOrderState> emit) async {
    emit(PaymentOrderLoading());
    try {
      final orderId = await _orderRepository.createPaymentOrder(event.cart);

      emit(PaymentOrderLoaded(orderId));
    } catch (e) {
      emit(PaymentOrderError(e.toString()));
    }
  }

  Future<void> _clearPaymentOrder(CartClearEvent event, Emitter<PaymentOrderState> emit) async {
    emit(PaymentOrderInitial());
  }

  Future<void> _queryPaymentOrder(QueryPaymentOrderEvent event, Emitter<PaymentOrderState> emit) async {
    emit(QueryPaymentOrderLoading());
    try {
      final paymentState = await _orderRepository.queryPaymentOrder(event.orderId);

      emit(QueryPaymentOrderLoaded(paymentState));
    } catch (e) {
      emit(QueryPaymentOrderError(e.toString()));
    }
  }
}


import '../service/api_client.dart';
import 'package:model/model.dart';

class OrderRepo {
  final ApiClient apiClient;

  const OrderRepo({required this.apiClient});

  Future<List<Order>> getOrders() async {
    final response = await apiClient.getOrders();

    if (response is List) {
      return response.map((json) {
        return Order.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Failed to load categories from the API');
    }
  }
}

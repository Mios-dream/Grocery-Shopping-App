import 'package:models/models.dart';

import '../service/api_client.dart';

class ProductRepo {
  final ApiClient apiClient;

  const ProductRepo({required this.apiClient});

  Future<List<Product>> getProducts() async {
    final response = await apiClient.getProducts();

    if (response is List) {
      return response
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products from the API');
    }
  }

  Future<List<Product>> getProductsByCategoryId(String categoryId) async {
    final response = await apiClient.getProductsByCategoryId(categoryId);

    if (response is List) {
      return response
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products from the API');
    }
  }
}

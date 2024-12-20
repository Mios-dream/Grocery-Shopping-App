import 'package:model/model.dart';

import '../service/api_client.dart';

class CartRepo {
  final ApiClient apiClient;

  const CartRepo({required this.apiClient});

  Future<Cart> getCart(String userId) async {
    final response = await apiClient.getCartItems(userId);

    if (response is List) {
      final cartItems = response.map((json) {
        return CartItem.fromJson(json);
      }).toList();

      return Cart(cartItems: cartItems, userId: userId);
    } else {
      throw Exception('Failed to load products from the API');
    }
  }

  Future<CartItem> addToCart(String userId, Product product) async {
    final response = await apiClient.addToCart(userId, product.toJson());
    if (response is Map<String, dynamic>) {
      return CartItem.fromJson(response);
    } else {
      throw Exception('Failed to add product to cart');
    }
  }

  Future<void> removeFromCart(String userId, String itemId) async {
    final response = await apiClient.removeFromCart(userId, itemId);

    if (response is String) {
      return;
    } else {
      throw Exception('Failed to remove item to cart');
    }
  }

  Future<void> clearCart(String userId) async {
    final response = await apiClient.removeFromCart(userId, "");

    if (response is String) {
      return;
    } else {
      throw Exception('Failed to remove item to cart');
    }
  }

}

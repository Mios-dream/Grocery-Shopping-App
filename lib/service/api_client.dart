import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:model/model.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    required String baseUrl,
  }) : this._(
          baseUrl: baseUrl,
          httpClient: httpClient,
        );

  ApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<dynamic> getCategoryByID(categoryId) {
    final uri = Uri.parse('$_baseUrl/categories/$categoryId');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  Future<dynamic> getCategories() {
    final uri = Uri.parse('$_baseUrl/categories');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  Future<dynamic> getProductsByCategoryID(String categoryId) {
    final uri = Uri.parse('$_baseUrl/categories/$categoryId/products');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  Future<dynamic> getProducts() {
    final uri = Uri.parse('$_baseUrl/products');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  // Fetch cart items for a specific user
  Future<dynamic> getCartItems(String userId) {
    final uri = Uri.parse('$_baseUrl/users/$userId/cart');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  // Add an item to the cart of a specific user
  Future<dynamic> addToCart(String userId, Map<String, dynamic> item) {
    final uri = Uri.parse('$_baseUrl/users/$userId/cart');
    return _handleRequest(
      (headers) =>
          _httpClient.post(uri, headers: headers, body: json.encode(item)),
    );
  }

  // Remove an item from the cart of a specific user
  Future<dynamic> removeFromCart(String userId, String itemId) {
    final uri = Uri.parse('$_baseUrl/users/$userId/cart/$itemId');
    return _handleRequest(
      (headers) => _httpClient.delete(uri, headers: headers),
    );
  }

  Future<dynamic> getOrders() {
    final uri = Uri.parse('$_baseUrl/orders');
    return _handleRequest(
      (headers) => _httpClient.get(uri, headers: headers),
    );
  }

  Future<dynamic> queryPaymentOrder(String orderId) async {
    final uri = Uri.parse('$_baseUrl/payment/query-order');
    return _handleRequest(
      (headers) => _httpClient.post(
        uri,
        headers: headers,
        body: json.encode({
          "order_id": orderId,
        }),
      ),
    );
  }

  Future<dynamic> createPaymentOrder(Cart cart) async {
    final uri = Uri.parse('$_baseUrl/payment/create-order');
    return _handleRequest(
        (headers) => _httpClient.post(uri, headers: headers, body: json.encode({
              "user_id": cart.userId,
              "amount": cart.totalPrice,
              "items": cart.cartItems.map((e) => e.product.name).toList(),
            })));
  }

  Future<dynamic> _handleRequest(
    Future<http.Response> Function(Map<String, String>) request,
  ) async {
    try {
      final headers = await _getRequestHeaders();
      final response = await request(headers);
      final body = jsonDecode(response.body);

      if (response.statusCode != HttpStatus.ok) {
        throw Exception('${response.statusCode}, error: ${body['message']}');
      }
      return body;
    } on TimeoutException {
      throw Exception('Request timeout. Please try again');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    };
  }
}

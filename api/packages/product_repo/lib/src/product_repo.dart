import 'package:model/model.dart';

class ProductRepo {
  Product emptyProduct = Product.empty;

  Future<Product> getProductByID(String productId) async {
    return Product.sampleData.firstWhere(
      (product) => product.id == productId,
    );
  }

  Future<List<Product>> getProductsByCategoryID(String categoryId) async {
    return Product.sampleData
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  Future<List<Product>> getProducts() async {
    return Product.sampleData;
  }

  Future<List<Product>> getPopularProducts() async {
    return Product.sampleData.where((product) => product.isPopular).toList();
  }

  Future<List<Product>> getTrendingProducts() async {
    return Product.sampleData.where((product) => product.isTrending).toList();
  }

// Future<Product> getProductById(String productId) async {
//   return emptyProduct.sampleData.firstWhere(
//     (product) => product.id == productId,
//   );
// }
//
// Future<List<Product>> getProductsByCategoryId(String categoryId) async {
//   return emptyProduct.sampleData
//       .where((product) => product.categoryId == categoryId)
//       .toList();
// }
//
// Future<List<Product>> getProducts() async {
//   return emptyProduct.sampleData;
// }
//
// Future<List<Product>> getPopularProducts() async {
//   return emptyProduct.sampleData.where((product) => product.isPopular).toList();
// }
//
// Future<List<Product>> getTrendingProducts() async {
//   return emptyProduct.sampleData.where((product) => product.isTrending).toList();
// }
}

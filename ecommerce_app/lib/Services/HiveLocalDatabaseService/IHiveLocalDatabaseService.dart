import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';

abstract class IHiveLocalDatabaseService {
  Future<bool> addProductToCart({required ProductBO productBO});

  Future<List<ProductBO>> getCartProducts();

  Future<bool> removeProductFromCart({required int id});

  Future<void> updateProductQuantity({required int id, required int quantity});
}

import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';

abstract class IProductAPIService {
  Future<List<ProductBO>> getAllProducts();
}
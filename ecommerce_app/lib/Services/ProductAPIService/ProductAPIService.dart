import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';
import 'package:ecommerce_app/Helpers/Utilities/Utilities.dart';
import 'package:ecommerce_app/Services/ProductAPIService/IProductAPIService.dart';
import 'package:dio/dio.dart';

class ProductAPIService implements IProductAPIService {
  final dio = Dio();

  @override
  Future<List<ProductBO>> getAllProducts() async {
    try {
      Response response = await dio.get('https://fakestoreapi.com/products');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => ProductBO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (ex) {
      ex.logException();
      return [];
    }
  }
}

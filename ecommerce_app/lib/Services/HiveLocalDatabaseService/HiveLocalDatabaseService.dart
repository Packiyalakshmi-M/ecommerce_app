import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';
import 'package:ecommerce_app/Helpers/Utilities/Utilities.dart';
import 'package:ecommerce_app/Services/HiveLocalDatabaseService/IHiveLocalDatabaseService.dart';
import 'package:hive/hive.dart';

class HiveLocalDatabaseService implements IHiveLocalDatabaseService {
  static final Box<ProductBO> _cartBox = Hive.box<ProductBO>('cartBox');

  @override
  Future<bool> addProductToCart({required ProductBO productBO}) async {
    try {
      if (!_cartBox.values.any((item) => item.id == productBO.id)) {
        _cartBox.add(productBO);
        return true;
      }
      return false;
    } catch (ex) {
      ex.logException();
      return false;
    }
  }

  @override
  Future<List<ProductBO>> getCartProducts() async {
    try {
      return _cartBox.values.toList();
    } catch (ex) {
      ex.logException();
      return [];
    }
  }

  @override
  Future<bool> removeProductFromCart({required int id}) async {
    try {
      final productKey = _cartBox.keys.firstWhere(
        (key) => _cartBox.get(key)?.id == id,
        orElse: () => null,
      );

      if (productKey != null) {
        await _cartBox.delete(productKey);
        return true;
      }
      return false;
    } catch (ex) {
      ex.logException();
      return false;
    }
  }

  @override
  Future<void> updateProductQuantity(
      {required int id, required int quantity}) async {
    try {
      if (_cartBox.containsKey(id)) {
        final product = _cartBox.get(id);
        if (product != null) {
          await _cartBox.put(id, product.copyWith(quantity: quantity));
        }
      }
    } catch (ex) {
      ex.logException();
    }
  }
}

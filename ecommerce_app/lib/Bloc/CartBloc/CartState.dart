import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartSuccess extends CartState {
  final String message;
  CartSuccess(this.message);
}

class CartFailure extends CartState {
  final String message;
  CartFailure(this.message);
}

class CartLoaded extends CartState {
  final List<ProductBO> cartItems;
  final num totalPrice;

  CartLoaded(this.cartItems, {this.totalPrice = 0});
}

class CartEmpty extends CartState {}

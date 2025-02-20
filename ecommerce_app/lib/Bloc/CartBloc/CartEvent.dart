import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final ProductBO product;
  AddToCartEvent(this.product);
}

class LoadCartEvent extends CartEvent {}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  RemoveFromCartEvent(this.productId);
}

class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;
  UpdateQuantityEvent(this.productId, this.newQuantity);
}

import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductBO> products;
  ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

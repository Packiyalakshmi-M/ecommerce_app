import 'package:ecommerce_app/Bloc/ProductBloc/ProductEvent.dart';
import 'package:ecommerce_app/Bloc/ProductBloc/ProductState.dart';
import 'package:ecommerce_app/Services/ProductAPIService/IProductAPIService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductAPIService productAPIService =
      GetIt.instance<IProductAPIService>();

  ProductBloc() : super(ProductInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productAPIService.getAllProducts();
        emit(ProductLoaded(products: products));
      } catch (e) {
        emit(ProductError(message: e.toString()));
      }
    });
  }
}

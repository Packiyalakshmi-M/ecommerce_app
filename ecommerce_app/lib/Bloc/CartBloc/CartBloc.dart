import 'package:ecommerce_app/Bloc/CartBloc/CartEvent.dart';
import 'package:ecommerce_app/Bloc/CartBloc/cartState.dart';
import 'package:ecommerce_app/Services/HiveLocalDatabaseService/IHiveLocalDatabaseService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final IHiveLocalDatabaseService hiveLocalDatabaseService =
      GetIt.instance<IHiveLocalDatabaseService>();

  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) async {
      bool isAdded = await hiveLocalDatabaseService.addProductToCart(
          productBO: event.product);
      if (isAdded) {
        emit(CartSuccess("${event.product.title} added to cart!"));
      } else {
        emit(CartFailure("${event.product.title} is already in the cart!"));
      }
    });

    on<LoadCartEvent>((event, emit) async {
      final items = await hiveLocalDatabaseService.getCartProducts();
      if (items.isEmpty) {
        emit(CartEmpty());
      } else {
        num totalPrice = 0;
        for (var item in items) {
          totalPrice = totalPrice + item.quantity * item.price;
        }
        emit(CartLoaded(items, totalPrice: totalPrice));
      }
    });

    on<RemoveFromCartEvent>((event, emit) async {
      bool isRemoved = await hiveLocalDatabaseService.removeProductFromCart(
          id: event.productId);
      if (isRemoved) {
        final updatedItems = await hiveLocalDatabaseService.getCartProducts();
        if (updatedItems.isEmpty) {
          emit(CartEmpty());
        } else {
          emit(CartLoaded(updatedItems));
        }
      } else {
        emit(CartFailure("Failed to remove item"));
      }
    });

    on<UpdateQuantityEvent>((event, emit) async {
      // Retrieve the existing cart items
      final currentState = state;
      if (currentState is CartLoaded) {
        final updatedCartItems = currentState.cartItems.map((product) {
          if (product.id == event.productId) {
            return product.copyWith(quantity: event.newQuantity);
          }
          return product;
        }).toList();

        // Update the quantity in Hive
        await hiveLocalDatabaseService.updateProductQuantity(
          id: event.productId,
          quantity: event.newQuantity,
        );

        // Recalculate total price
        // final totalPrice = updatedCartItems.fold<num>(
        //   0,
        //   (sum, item) => sum + (item.price * item.quantity),
        // );
        num totalPrice = 0;
        for (var item in updatedCartItems) {
          totalPrice = totalPrice + item.quantity * item.price;
        }

        // Emit updated cart state
        emit(CartLoaded(updatedCartItems, totalPrice: totalPrice));
      }
    });
  }
}

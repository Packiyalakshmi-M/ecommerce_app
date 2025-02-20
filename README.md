# Flutter - E-Commerce App

This E-Commerce App is a Flutter-based mobile application that displays products in a grid layout and allows users to add them to a cart. The app follows a clean architecture and uses Bloc for state management, Dio for API integration, and Hive for local storage.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Folder Structure](#folder-structure)
- [Usage](#usage)
- [Author](#author)

## Features

- **Product Listing:** Displays products in a grid format with images, titles, prices, and categories.
- **Cart Management:** Users can add, remove, and update product quantities in the cart.
- **State Management:** Uses Bloc to handle product and cart state.
- **API Integration:** Uses Dio for fetching product data from a REST API.
- **Local Storage:** Saves cart products using Hive, ensuring data persists even after restarting the app.
- **Total Price Calculation:** Dynamically updates the total price at the bottom of the cart screen.

## Technologies Used

- **Programming Language:** Dart
- **Framework:** Flutter
- **State Management:** Bloc state management
- **Dependency Injection:** GetIt package
- **Networking:** dio package for API calls
- **Local database:** hive package for handling the cart details
- **IDE:** Android Studio / Visual Studio Code
- **Version Control:** Git

## Installation

Follow these steps to get the project up and running locally:

```bash
# Clone the repository
git clone https://github.com/Packiyalakshmi-M/ecommerce_app.git

# Navigate into the project directory
cd ecommerce_app

# Install dependencies
flutter pub get

```

## Folder Structure

The project follows a below structure for better maintainability and scalability:

```bash

lib  
  - Bloc  # Manages app state using Bloc for Cart and Product operations**  
    - CartBloc  
      - CartBloc.dart  # Handles business logic for cart operations**  
      - CartEvent.dart  # Defines events for cart interactions**  
      - CartState.dart  # Defines states for the cart UI**  
    - ProductBloc  
      - ProductBloc.dart  # Handles business logic for product listing**  
      - ProductEvent.dart  # Defines events for product interactions**  
      - ProductState.dart  # Defines states for product UI**  
  - BOs  # Contains Business Objects (BOs) for managing data models**  
    - ProductBO  
      - ProductBO.dart  # Defines Product data model**  
    - RatingBO  
      - RatingBO.dart  # Defines Rating data model**  
  - Helpers  # Utility classes and app-wide constants**  
    - AppConstants  
      - AppConstants.dart  # Stores static constants used across the app**  
    - Utilities  
      - Utilities.dart  # Helper functions for common operations**  
    - ResponsiveUI.dart  # Handles UI scaling for different screen sizes**  
  - Pages  # Contains all app screens**  
    - ProductScreen  
      - ProductScreen.dart  # Displays the product listing page**  
    - CartScreen  
      - CartScreen.dart  # Displays cart items and total price**  
    - SplashScreen  
      - SplashScreen.dart  # Initial splash screen of the app**  
  - Resources  # Contains app styling resources**  
    - AppColors  
      - AppColors.dart  # Defines app-wide color themes**  
  - Services  # Handles API calls and local database operations**  
    - HiveLocalDatabaseService  
      - IHiveLocalDatabaseService.dart  # Abstract class for local storage service**  
      - HiveLocalDatabaseService.dart  # Implements Hive database operations**  
    - ProductAPIService  
      - IProductAPIService.dart  # Abstract class for API service**  
      - ProductAPIService.dart  # Implements API calls using Dio**  
  - App.dart  # Main app widget**  
  - main.dart  # Entry point of the application**  

```

## Usage

### API Integration

- Uses **Dio** to fetch products from an API.
- API response is mapped to a **List<ProductBO>**.
- The ProductBO model handles RatingBO for nested JSON parsing.

```

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

```

### State Management - Bloc

- The product and cart fundtionalities are handled by using Bloc state management.

```

// Product Bloc
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


```

```

// Cart Bloc
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

```

### Hive Local Database

- Hive local database is used for adding the product into cart, get all cart products from hive, updating the product quantity and remove a product from cart.

```

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

```

### UI Implementation

- **Products Screen:** - Gridview builder is used for displaying the list of products.
- **Cart Screen:** - Listview builder is used for displaying the list of products added in cart.

## Author

- Packiyalakshmi Murugan
- [LinkedIn Link](https://www.linkedin.com/in/packiyalakshmi-m-7a9844210/)
- [Github link](https://github.com/Packiyalakshmi-M/)

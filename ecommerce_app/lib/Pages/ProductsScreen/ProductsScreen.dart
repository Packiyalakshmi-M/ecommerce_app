import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';
import 'package:ecommerce_app/Bloc/CartBloc/CartBloc.dart';
import 'package:ecommerce_app/Bloc/CartBloc/CartEvent.dart';
import 'package:ecommerce_app/Bloc/CartBloc/cartState.dart';
import 'package:ecommerce_app/Helpers/ResponsiveUI.dart';
import 'package:ecommerce_app/Pages/CartScreen/CartScreen.dart';
import 'package:ecommerce_app/Bloc/ProductBloc/ProductBloc.dart';
import 'package:ecommerce_app/Bloc/ProductBloc/ProductEvent.dart';
import 'package:ecommerce_app/Bloc/ProductBloc/ProductState.dart';
import 'package:ecommerce_app/Resources/AppColors/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: BlocProvider(
        create: (context) => ProductBloc()..add(LoadProducts()),
        child: ProductGridView(),
      ),
    );
  }
}

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CartBloc()),
          ],
          child: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartSuccess || state is CartFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state is CartSuccess
                        ? state.message
                        : (state as CartFailure).message),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.45,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductCard(product: product);
                      },
                    ),
                  );
                } else if (state is ProductError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: Text('No data available'));
              },
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Cart screen!",
        child: FloatingActionButton(
          backgroundColor: AppColors.appBackgroundColor,
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CartScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                      position: animation.drive(tween), child: child);
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Icon(
                Icons.shopping_cart_rounded,
                size: ResponsiveUI.h(28, context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductBO product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: AppColors.productCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textColorBlack,
                    fontSize: ResponsiveUI.sp(12, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUI.h(10, context),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: AppColors.priceTextColor,
                    fontSize: ResponsiveUI.sp(14, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUI.h(10, context),
                ),
                Text(
                  'Category: ${product.category}',
                  style: TextStyle(
                    color: AppColors.textColorBlack,
                    fontSize: ResponsiveUI.sp(10, context),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUI.h(10, context),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.ratingStarColor,
                      size: 16,
                    ),
                    Text(
                      '${product.rating.rate}',
                      style: TextStyle(
                        color: AppColors.textColorBlack,
                        fontSize: ResponsiveUI.sp(10, context),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveUI.h(10, context),
                ),
                Text(
                  'Stock: ${product.rating.count}',
                  style: TextStyle(
                    color: AppColors.productStockTextColor,
                    fontSize: ResponsiveUI.sp(12, context),
                  ),
                ),
                SizedBox(
                  height: ResponsiveUI.h(15, context),
                ),
                SizedBox(
                  height: ResponsiveUI.h(45, context),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(AddToCartEvent(product));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: AppColors.textColorWhite,
                      minimumSize: Size(double.infinity, 30),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        color: AppColors.textColorWhite,
                        fontSize: ResponsiveUI.sp(12, context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

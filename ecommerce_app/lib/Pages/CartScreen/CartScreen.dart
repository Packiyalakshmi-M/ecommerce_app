import 'dart:math';

import 'package:ecommerce_app/Bloc/CartBloc/CartBloc.dart';
import 'package:ecommerce_app/Bloc/CartBloc/CartEvent.dart';
import 'package:ecommerce_app/Bloc/CartBloc/cartState.dart';
import 'package:ecommerce_app/Helpers/ResponsiveUI.dart';
import 'package:ecommerce_app/Resources/AppColors/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset(); // Reset after shake animation
      }
    });
  }

  Future<void> _startShake() async {
    await _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "My Cart",
        style: TextStyle(
          color: AppColors.textColorBlack,
          fontSize: ResponsiveUI.sp(16, context),
          fontWeight: FontWeight.bold,
        ),
      )),
      body: BlocProvider(
        create: (context) => CartBloc()..add(LoadCartEvent()),
        child: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CartInitial) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CartEmpty) {
              return Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(
                    color: AppColors.textColorBlack,
                    fontSize: ResponsiveUI.sp(12, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (state is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final product = state.cartItems[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Image.network(
                              product.image,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              product.title,
                              style: TextStyle(
                                color: AppColors.textColorBlack,
                                fontSize: ResponsiveUI.sp(12, context),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    color: AppColors.priceTextColor,
                                    fontSize: ResponsiveUI.sp(12, context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (product.quantity > 1) {
                                          context.read<CartBloc>().add(
                                                UpdateQuantityEvent(product.id,
                                                    product.quantity - 1),
                                              );
                                        }
                                      },
                                    ),
                                    Text(
                                      "${product.quantity}",
                                      style: TextStyle(
                                        color: AppColors.productStockTextColor,
                                        fontSize: ResponsiveUI.sp(10, context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                              UpdateQuantityEvent(product.id,
                                                  product.quantity + 1),
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                      sin(_shakeAnimation.value * pi) * 5,
                                      0), // Shake Effect
                                  child: child,
                                );
                              },
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: AppColors.buttonColor,
                                ),
                                onPressed: () {
                                  _startShake();
                                  context.read<CartBloc>().add(
                                        RemoveFromCartEvent(product.id),
                                      );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product Details (${state.cartItems.length} items)",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.productStockTextColor,
                            fontSize: ResponsiveUI.sp(12, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...state.cartItems.map((product) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Text(
                                    product.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textColorBlack,
                                      fontSize: ResponsiveUI.sp(12, context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${product.quantity}",
                                  style: TextStyle(
                                    color: AppColors.textColorBlack,
                                    fontSize: ResponsiveUI.sp(12, context),
                                  ),
                                ),
                                Text(
                                  "\$${product.price}",
                                  style: TextStyle(
                                    color: AppColors.textColorBlack,
                                    fontSize: ResponsiveUI.sp(12, context),
                                  ),
                                ),
                                Text(
                                  "\$${(product.price * product.quantity).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: AppColors.textColorBlack,
                                    fontSize: ResponsiveUI.sp(12, context),
                                  ),
                                ),
                              ],
                            )),
                        Divider(),
                        Text(
                          "Total Price: \$${state.totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: AppColors.textColorBlack,
                            fontSize: ResponsiveUI.sp(18, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Center(child: Text("Error loading cart"));
          },
        ),
      ),
    );
  }
}

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(
//         "My Cart",
//         style: TextStyle(
//           color: AppColors.textColorBlack,
//           fontSize: ResponsiveUI.sp(16, context),
//           fontWeight: FontWeight.bold,
//         ),
//       )),
//       body: BlocProvider(
//         create: (context) => CartBloc()..add(LoadCartEvent()),
//         child: BlocConsumer<CartBloc, CartState>(
//           listener: (context, state) {
//             if (state is CartFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//           builder: (context, state) {
//             if (state is CartInitial) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is CartEmpty) {
//               return Center(
//                 child: Text(
//                   "Your cart is empty",
//                   style: TextStyle(
//                     color: AppColors.textColorBlack,
//                     fontSize: ResponsiveUI.sp(12, context),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               );
//             } else if (state is CartLoaded) {
//               return Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: state.cartItems.length,
//                       itemBuilder: (context, index) {
//                         final product = state.cartItems[index];
//                         return Card(
//                           margin:
//                               EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           child: ListTile(
//                             leading: Image.network(
//                               product.image,
//                               width: 50,
//                               height: 50,
//                             ),
//                             title: Text(
//                               product.title,
//                               style: TextStyle(
//                                 color: AppColors.textColorBlack,
//                                 fontSize: ResponsiveUI.sp(12, context),
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "\$${product.price}",
//                                   style: TextStyle(
//                                     color: AppColors.priceTextColor,
//                                     fontSize: ResponsiveUI.sp(12, context),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.remove),
//                                       onPressed: () {
//                                         if (product.quantity > 1) {
//                                           context.read<CartBloc>().add(
//                                                 UpdateQuantityEvent(product.id,
//                                                     product.quantity - 1),
//                                               );
//                                         }
//                                       },
//                                     ),
//                                     Text(
//                                       "${product.quantity}",
//                                       style: TextStyle(
//                                         color: AppColors.productStockTextColor,
//                                         fontSize: ResponsiveUI.sp(10, context),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.add),
//                                       onPressed: () {
//                                         context.read<CartBloc>().add(
//                                               UpdateQuantityEvent(product.id,
//                                                   product.quantity + 1),
//                                             );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             trailing: IconButton(
//                               icon: Icon(
//                                 Icons.close,
//                                 color: AppColors.buttonColor,
//                               ),
//                               onPressed: () {
//                                 context.read<CartBloc>().add(
//                                       RemoveFromCartEvent(product.id),
//                                     );
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   Divider(),
//                   Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Product Details (${state.cartItems.length} items)",
//                           textAlign: TextAlign.left,
//                           style: TextStyle(
//                             color: AppColors.productStockTextColor,
//                             fontSize: ResponsiveUI.sp(12, context),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         ...state.cartItems.map((product) => Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width / 4,
//                                   child: Text(
//                                     product.title,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       color: AppColors.textColorBlack,
//                                       fontSize: ResponsiveUI.sp(12, context),
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   "${product.quantity}",
//                                   style: TextStyle(
//                                     color: AppColors.textColorBlack,
//                                     fontSize: ResponsiveUI.sp(12, context),
//                                   ),
//                                 ),
//                                 Text(
//                                   "\$${product.price}",
//                                   style: TextStyle(
//                                     color: AppColors.textColorBlack,
//                                     fontSize: ResponsiveUI.sp(12, context),
//                                   ),
//                                 ),
//                                 Text(
//                                   "\$${(product.price * product.quantity).toStringAsFixed(2)}",
//                                   style: TextStyle(
//                                     color: AppColors.textColorBlack,
//                                     fontSize: ResponsiveUI.sp(12, context),
//                                   ),
//                                 ),
//                               ],
//                             )),
//                         Divider(),
//                         Text(
//                           "Total Price: \$${state.totalPrice.toStringAsFixed(2)}",
//                           style: TextStyle(
//                             color: AppColors.textColorBlack,
//                             fontSize: ResponsiveUI.sp(18, context),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return Center(child: Text("Error loading cart"));
//           },
//         ),
//       ),
//     );
//   }
// }

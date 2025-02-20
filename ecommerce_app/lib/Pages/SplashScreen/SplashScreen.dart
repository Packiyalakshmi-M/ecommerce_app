import 'package:ecommerce_app/Helpers/AppConstants/AppConstants.dart';
import 'package:ecommerce_app/Helpers/ResponsiveUI.dart';
import 'package:ecommerce_app/Pages/ProductsScreen/ProductsScreen.dart';
import 'package:ecommerce_app/Resources/AppColors/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ProductsScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        body: Center(
          child: SizedBox(
            height: ResponsiveUI.h(AppConstants.baseHeight, context),
            width: ResponsiveUI.w(AppConstants.baseWidth, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'E-commerce App',
                  style: TextStyle(
                    color: AppColors.textColorWhite,
                    fontSize: ResponsiveUI.sp(43, context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

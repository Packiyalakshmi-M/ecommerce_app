import 'package:ecommerce_app/App.dart';
import 'package:ecommerce_app/BOs/ProductBO/ProductBO.dart';
import 'package:ecommerce_app/BOs/RatingBO/RatingBO.dart';
import 'package:ecommerce_app/Services/HiveLocalDatabaseService/HiveLocalDatabaseService.dart';
import 'package:ecommerce_app/Services/HiveLocalDatabaseService/IHiveLocalDatabaseService.dart';
import 'package:ecommerce_app/Services/ProductAPIService/IProductAPIService.dart';
import 'package:ecommerce_app/Services/ProductAPIService/ProductAPIService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ProductBOAdapter());
  Hive.registerAdapter(RatingBOAdapter());

  // Open Hive Box for storing cart items
  await Hive.openBox<ProductBO>('cartBox');

  runApp(const App());

  // Register services
  getIt.registerSingleton<IProductAPIService>(ProductAPIService());

  getIt
      .registerSingleton<IHiveLocalDatabaseService>(HiveLocalDatabaseService());
}

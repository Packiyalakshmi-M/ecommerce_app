import 'package:ecommerce_app/BOs/RatingBO/RatingBO.dart';
import 'package:hive/hive.dart';

part 'ProductBO.g.dart';

@HiveType(typeId: 1)
class ProductBO extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  num price;

  @HiveField(3)
  String description;

  @HiveField(4)
  String category;

  @HiveField(5)
  String image;

  @HiveField(6)
  RatingBO rating;

  @HiveField(7)
  int quantity;

  ProductBO({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.quantity = 1,
  });

  /// Factory method to create an instance from a JSON object
  factory ProductBO.fromJson(Map<String, dynamic> json) {
    return ProductBO(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating:
          RatingBO.fromJson(json['rating']), // Convert nested JSON to RatingBO
    );
  }

  ProductBO copyWith({int? quantity}) {
    return ProductBO(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating,
      quantity: quantity ?? this.quantity,
    );
  }
}

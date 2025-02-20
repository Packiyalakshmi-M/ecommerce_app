import 'package:hive/hive.dart';

part 'RatingBO.g.dart';

@HiveType(typeId: 2)
class RatingBO extends HiveObject {
  @HiveField(0)
  num rate;

  @HiveField(1)
  num count;

  RatingBO({required this.rate, required this.count});

  /// Factory method to create an instance from a JSON object
  factory RatingBO.fromJson(Map<String, dynamic> json) {
    return RatingBO(
      rate: json['rate'],
      count: json['count'],
    );
  }
}

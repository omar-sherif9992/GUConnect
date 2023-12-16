import 'package:GUConnect/src/models/UserRating.dart';

class Rating {
  late String id;
  double ratingSum;
  double ratingAverage;
  int ratingCount;

  Rating({
    required this.id,
    required this.ratingSum,
    required this.ratingAverage,
    required this.ratingCount,
  });

  Rating.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ratingSum = json['ratingSum'],
        ratingAverage = json['ratingAverage'],
        ratingCount = json['ratingCount'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'ratingSum': ratingSum,
        'ratingAverage': ratingAverage,
        'ratingCount': ratingCount
      };

  @override
  String toString() {
    return 'Rating(id: $id, ratingSum: $ratingSum, ratingAverage: $ratingAverage, ratingCount: $ratingCount)';
  }
}

import 'package:GUConnect/src/models/Rating.dart';
import 'package:GUConnect/src/models/UserRating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<Rating> addRating(UserRating userRating, String id) async {
    _isLoading = true;
    notifyListeners();
    final ratingRef = firestore.collection('ratings').doc(id);
    final ratingDoc = await ratingRef.get();
    Rating newRatingData;
    if (ratingDoc.exists) {
      final Rating ratingData = Rating.fromJson(ratingDoc.data()!);
      newRatingData = Rating(
        id: ratingData.id,
        ratingSum: ratingData.ratingSum + userRating.rating,
        ratingAverage: (ratingData.ratingSum + userRating.rating) /
            (ratingData.ratingCount + 1),
        ratingCount: ratingData.ratingCount + 1,
      );
      await ratingRef.update(newRatingData.toJson());
    } else {
      newRatingData = Rating(
        id: id,
        ratingSum: userRating.rating,
        ratingAverage: userRating.rating,
        ratingCount: 1,
      );
      await ratingRef.set(newRatingData.toJson());
    }
    await ratingRef.collection('userRatings').doc(userRating.userId).set(
          userRating.toJson(),
        );
    _isLoading = false;
    notifyListeners();
    return newRatingData;
  }

  Future<Rating?> deleteRating(String id, String userId) async {
    _isLoading = true;
    notifyListeners();
    final ratingRef = firestore.collection('ratings').doc(id);
    final ratingDoc = await ratingRef.get();
    if (ratingDoc.exists) {
      final Rating ratingData = Rating.fromJson(ratingDoc.data()!);
      final userRatingDoc =
          await ratingRef.collection('userRatings').doc(userId).get();
      if (userRatingDoc.exists) {
        final UserRating userRating =
            UserRating.fromJson(userRatingDoc.data()!);
        final Rating newRatingData = Rating(
          id: ratingData.id,
          ratingSum: ratingData.ratingSum - userRating.rating,
          ratingAverage: (ratingData.ratingSum - userRating.rating) /
              ((ratingData.ratingCount - 1) == 0
                  ? 1
                  : (ratingData.ratingCount - 1)),
          ratingCount: ratingData.ratingCount - 1,
        );
        await ratingRef.update(newRatingData.toJson());
        await ratingRef.collection('userRatings').doc(userId).delete();
        _isLoading = false;
        notifyListeners();
        return newRatingData;
      }
    }
  }

  Future<UserRating> getUserRating(String id, String userId) async {
    final ratingRef = firestore.collection('ratings').doc(id);
    final ratingDoc = await ratingRef.get();
    if (ratingDoc.exists) {
      final userRatingDoc =
          await ratingRef.collection('userRatings').doc(userId).get();
      if (userRatingDoc.exists) {
        return UserRating.fromJson(userRatingDoc.data()!);
      }
    }
    return UserRating(
      userId: userId,
      rating: 0,
    );
  }

  Future<Rating> getRating(String id) async {
    final ratingRef = firestore.collection('ratings').doc(id);
    final ratingDoc = await ratingRef.get();
    if (ratingDoc.exists) {
      return Rating.fromJson(ratingDoc.data()!);
    }
    final Rating rating = Rating(
      id: id,
      ratingSum: 0,
      ratingAverage: 0,
      ratingCount: 0,
    );
    ratingRef.set(rating.toJson());
    return rating;
  }
}

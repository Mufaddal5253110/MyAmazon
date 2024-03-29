import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    @required this.description,
    this.isFav = false,
  });

  Future<void> toogleFavourites(String userId, String token) async {
    try {
      final url =
          'https://workouttraining-ff114.firebaseio.com/Favourites/$userId/$id.json?auth=$token';
      isFav = !isFav;
      notifyListeners();
      final response = await http.put(
        url,
        body: json.encode(isFav),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        //prod = null;
      } else {
        isFav = !isFav;
        notifyListeners();
        throw "error";
      }
    } catch (error) {
      throw error;
    }
  }
}

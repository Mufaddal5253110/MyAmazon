import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favProducts {
    return [..._products.where((element) => element.isFav)];
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final url =
        'https://workouttraining-ff114.firebaseio.com/products/$id.json';
    await http.patch(
      url,
      body: json.encode({
        "description": updatedProduct.description,
        "imageUrl": updatedProduct.imageUrl,
        "price": updatedProduct.price,
        "title": updatedProduct.title,
      }),
    );
    final index = _products.indexWhere((element) => element.id == id);
    _products[index] = updatedProduct;
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      const url = 'https://workouttraining-ff114.firebaseio.com/products.json';
      final response = await http.get(url);
      print(json.decode(response.body));
      final Map<String, dynamic> allProduct = json.decode(response.body);
      final List<Product> product = [];
      allProduct.forEach((prodId, prodData) {
        product.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFav: prodData['isFav'],
        ));
      });
      _products = product;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      const url = 'https://workouttraining-ff114.firebaseio.com/products.json';
      final response = await http.post(
        url,
        body: json.encode({
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "title": product.title,
          "isFav": product.isFav,
        }),
      );
      print(json.decode(response.body));
      final newProduct = Product(
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
        id: json.decode(response.body)['name'],
      );
      _products.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url = 'https://workouttraining-ff114.firebaseio.com/products/$id.json';
      final prodIndex = _products.indexWhere((element) => element.id == id);
      var prod = _products[prodIndex];
      _products.removeWhere((element) => element.id == id);
      notifyListeners();
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        prod = null;
      } else {
        _products.insert(prodIndex, prod);
        notifyListeners();
        throw "error";
      }
    } catch (error) {
      throw error;
    }
  }
}

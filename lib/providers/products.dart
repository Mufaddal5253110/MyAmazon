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

  List<Product> _mineProducts = [];

  final String token;
  final String userId;

  Products(this.token, this.userId, this._products, this._mineProducts);

  List<Product> get products {
    return [..._products];
  }

  List<Product> get mineProducts {
    return [..._mineProducts];
  }

  List<Product> get favProducts {
    return [..._products.where((element) => element.isFav)];
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final url =
        'https://workouttraining-ff114.firebaseio.com/products/$id.json?auth=$token';
    await http.patch(
      url,
      body: json.encode({
        "description": updatedProduct.description,
        "imageUrl": updatedProduct.imageUrl,
        "price": updatedProduct.price,
        "title": updatedProduct.title,
        "createdBy": userId,
      }),
    );
    final index = _products.indexWhere((element) => element.id == id);
    final mineIndex = _mineProducts.indexWhere((element) => element.id == id);
    _products[index] = updatedProduct;
    _mineProducts[mineIndex] = updatedProduct;
    notifyListeners();
  }

  Future<void> getData([bool filtering = false]) async {
    final filteredUrl =
        filtering ? '&orderBy="createdBy"&equalTo="$userId"' : '';
    try {
      final url =
          'https://workouttraining-ff114.firebaseio.com/products.json?auth=$token$filteredUrl';
      final response = await http.get(url);
      print(response.statusCode);
      final Map<String, dynamic> allProduct = json.decode(response.body);
      final List<Product> product = [];
      final favResponse = await http.get(
          'https://workouttraining-ff114.firebaseio.com/Favourites/$userId/.json?auth=$token');
      final favRes = json.decode(favResponse.body);

      allProduct.forEach((prodId, prodData) {
        product.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFav: favRes == null ? false : favRes[prodId] ?? false,
        ));
      });
      _mineProducts = filtering ? product : _mineProducts;
      _products = filtering ? _products : product;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final url =
          'https://workouttraining-ff114.firebaseio.com/products.json?auth=$token';
      final response = await http.post(
        url,
        body: json.encode({
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "title": product.title,
          "createdBy": userId,
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
      _mineProducts.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url =
          'https://workouttraining-ff114.firebaseio.com/products/$id.json?auth=$token';
      final prodIndex = _products.indexWhere((element) => element.id == id);
      final mineProdIndex =
          _mineProducts.indexWhere((element) => element.id == id);
      var prod = _products[prodIndex];
      var mineProd = _mineProducts[mineProdIndex];
      _products.removeWhere((element) => element.id == id);
      _mineProducts.removeWhere((element) => element.id == id);
      notifyListeners();
      final response = await http.delete(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        prod = null;
      } else {
        _products.insert(prodIndex, prod);
        _mineProducts.insert(mineProdIndex,mineProd);
        notifyListeners();
        throw "error";
      }
    } catch (error) {
      throw error;
    }
  }
}

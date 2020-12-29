import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  String id;
  String title;
  String imageUrl;
  int quantity;
  double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  void addItemToCart(String id, String title, double price, String imageUrl) {
    if (_cart.containsKey(id)) {
      print("Already added");
      /*To increase quantity and price
      _cart.update(id , (existingcartitem) => CartItem(id: existingcartitem.id,
          price: existingcartitem.price,
          quantity: existingcartitem.quantity + 1,
          title: existingcartitem.title,))
      */
      _cart.remove(id);
    } else {
      _cart.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  int get cartCount {
    return _cart.length;
  }

  bool isAddedToCart(String id) {
    return _cart.containsKey(id);
  }

  double get totalPrice {
    var _totalPrice = 0.0;
    _cart.forEach((key, cartItem) {
      _totalPrice += cartItem.price * cartItem.quantity;
    });
    return _totalPrice;
  }

  void removeItem(String cartId) {
    _cart.remove(cartId);
    notifyListeners();
  }

  void increaseQuanity(String cartId) {
    _cart.update(
        cartId,
        (existingcartitem) => CartItem(
              id: existingcartitem.id,
              price: existingcartitem.price,
              quantity: existingcartitem.quantity + 1,
              title: existingcartitem.title,
              imageUrl: existingcartitem.imageUrl,
            ));
    notifyListeners();
  }

  void deacreseQuanity(String cartId, int initialQuantity) {
    if (initialQuantity > 1) {
      _cart.update(
          cartId,
          (existingcartitem) => CartItem(
                id: existingcartitem.id,
                price: existingcartitem.price,
                quantity: existingcartitem.quantity - 1,
                title: existingcartitem.title,
                imageUrl: existingcartitem.imageUrl,
              ));
    } else {
      removeItem(cartId);
    }
    notifyListeners();
  }

  void clear() {
    _cart = {};
    notifyListeners();
  }
}

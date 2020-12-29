import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> cartItem;
  final double totalAmount;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.cartItem,
    @required this.totalAmount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get ordres {
    return [..._orders];
  }

  Future<void> addOrders(List<CartItem> cartItem, double total) async {
    try {
      final url = 'https://workouttraining-ff114.firebaseio.com/orders.json';
      final timeStamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          "Products": cartItem
              .map((prod) => {
                    "id": prod.id,
                    "price": prod.price,
                    "title": prod.title,
                    "quantity": prod.quantity,
                    "imageUrl": prod.imageUrl,
                  })
              .toList(),
          "dateTime": timeStamp.toIso8601String(),
          "totalAmount": total,
        }),
      );
      print(json.decode(response.body));
      _orders.insert(
          0,
          OrderItem(
            cartItem: cartItem,
            id: json.decode(response.body)['name'],
            dateTime: timeStamp,
            totalAmount: total,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getOrders() async {
    try {
      const url = 'https://workouttraining-ff114.firebaseio.com/orders.json';
      final response = await http.get(url);
      //print(json.decode(response.body));
      if (json.decode(response.body) != null) {
        final Map<String, dynamic> allOrders = json.decode(response.body);
        final List<OrderItem> orders = [];
        allOrders.forEach((orderId, orderData) {
          orders.add(OrderItem(
            id: orderId,
            dateTime: DateTime.parse(orderData['dateTime']),
            totalAmount: orderData['totalAmount'],
            cartItem: (orderData['Products'] as List<dynamic>).map((prod) {
              return CartItem(
                id: prod['id'],
                title: prod['title'],
                price: prod['price'],
                quantity: prod['quantity'],
                imageUrl: prod['imageUrl'],
              );
            }).toList(),
          ));
        });
        _orders = orders.reversed.toList();
        notifyListeners();
      } else {
        return;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

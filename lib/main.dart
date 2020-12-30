import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_add_product.dart';

import './screens/user_products.dart';
import './screens/my_orders.dart';
import './providers/order.dart';
import './screens/cart_overview.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_detail.dart';
import './screens/product_overview.dart';
import './screens/login_signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Orders()),
      ],
      child: MaterialApp(
        title: 'My Amazon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          canvasColor: Colors.red[50],
          fontFamily: 'Lato' ,
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
        ),
        routes: {
          '/': (_) => LoginSignup(),
          ProductOverview.routeName: (_) => ProductOverview(),
          ProductDetail.routeName: (_) => ProductDetail(),
          CartOverview.routeName: (_) => CartOverview(),
          MyOrders.routeName: (_) => MyOrders(),
          UserProducts.routeName: (_) => UserProducts(),
          EditAddProduct.routeName: (_) => EditAddProduct(),
        },
      ),
    );
  }
}

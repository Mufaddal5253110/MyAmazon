import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_app/screens/splash_screen.dart';

import './providers/auth.dart';
import './screens/edit_add_product.dart';
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
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) => Products(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.products,
            previous == null ? [] : previous.mineProducts,
          ),
          create: null,
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
              auth.token, auth.userId, previous == null ? [] : previous.ordres),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'My Amazon',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            canvasColor: Colors.red[50],
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
          ),
          home: auth.isAuthenticated
              ? ProductOverview()
              : FutureBuilder(
                  future: auth.tryToAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginSignup(),
                ),
          routes: {
            ProductOverview.routeName: (_) => ProductOverview(),
            ProductDetail.routeName: (_) => ProductDetail(),
            CartOverview.routeName: (_) => CartOverview(),
            MyOrders.routeName: (_) => MyOrders(),
            UserProducts.routeName: (_) => UserProducts(),
            EditAddProduct.routeName: (_) => EditAddProduct(),
          },
        ),
      ),
    );
  }
}

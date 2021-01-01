import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/cart_overview.dart';
import '../screens/my_orders.dart';
import '../screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            leading: Icon(Icons.home),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text("My Orders"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(MyOrders.routeName);
            },
          ),
          Consumer<Cart>(
            builder: (context, value, child) => ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("My Cart"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(CartOverview.routeName,
                    arguments: value.cartCount);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.food_bank),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(UserProducts.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/cart_overview.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';

enum menuFilter {
  Favourites,
  All,
}

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool isFav = false;
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = !isLoading;
    });
    Provider.of<Products>(context, listen: false).getData().then((_) {
      setState(() {
        isLoading = !isLoading;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Amazon",
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartOverview.routeName,
                      arguments: value.cartCount);
                },
              ),
              value: value.cartCount.toString(),
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == menuFilter.Favourites) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: menuFilter.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show all"),
                value: menuFilter.All,
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductOverviewGrid(isFav),
      drawer: AppDrawer(),
    );
  }
}

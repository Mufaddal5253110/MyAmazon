import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context).settings.arguments;
    Product product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}

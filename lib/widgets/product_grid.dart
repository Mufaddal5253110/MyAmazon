import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductOverviewGrid extends StatelessWidget {
  final bool isFav;
  ProductOverviewGrid(this.isFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = isFav? productData.favProducts :productData.products;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

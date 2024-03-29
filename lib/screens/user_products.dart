import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_add_product.dart';
import 'package:shopping_app/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getData(true);
  }

  @override
  Widget build(BuildContext context) {
    print("Manage Product Build Run");
    //final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Products",
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return Consumer<Products>(
                builder: (context, productData, child) => ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) => UserProductItem(
                      productData.mineProducts[index].title,
                      productData.mineProducts[index].id,
                      productData.mineProducts[index].imageUrl),
                  itemCount: productData.mineProducts.length,
                ),
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditAddProduct.routeName, arguments: {
            'title': 'Add New Product',
            'id': null,
          });
        },
        child: Icon(
          Icons.add,
          size: MediaQuery.of(context).size.height * 0.06,
        ),
      ),
    );
  }
}

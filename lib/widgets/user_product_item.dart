import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import '../screens/edit_add_product.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  UserProductItem(this.title, this.id, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(
          title,
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditAddProduct.routeName, arguments: {
                  'title': 'Edit',
                  'id': id,
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id)
                    .catchError((_) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Deleting Failed"),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

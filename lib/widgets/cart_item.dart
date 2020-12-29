import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class EachCartItem extends StatelessWidget {
  final String productId;
  EachCartItem(this.productId);
  @override
  Widget build(BuildContext context) {
    CartItem cartItem = Provider.of<CartItem>(context);
    final cartData = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: slideLeftBackground(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => cartData.removeItem(productId),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Remove",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: Text(
                  "Are you sure you want to remove this item from the cart?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("NO"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text("YES"),
                  onPressed: () => Navigator.of(context).pop(true),
                )
              ],
            );
          },
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: ListTile(
          leading: Container(
            width: 50,
            child: Image.network(
              cartItem.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder:
                  (context, Widget child, ImageChunkEvent progress) {
                if (progress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
          title: Text(
            cartItem.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("₹${cartItem.price} x ${cartItem.quantity}"),
          trailing:
              quantityButton(cartItem.quantity, context, cartData, productId),
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Remove",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget quantityButton(
      int _quantity, BuildContext context, Cart data, String cartId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 35,
          width: 45,
          child: FlatButton(
            onPressed: () {
              data.deacreseQuanity(cartId, _quantity);

            },
            child: Icon(
              Icons.remove,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text(_quantity.toString()),
        ),
        Container(
          height: 35,
          width: 45,
          child: FlatButton(
            onPressed: () {
              data.increaseQuanity(cartId);
            },
            child: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

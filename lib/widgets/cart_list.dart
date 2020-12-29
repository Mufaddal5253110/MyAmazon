import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/order.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartList extends StatelessWidget {
  final double heightOfPage;
  CartList(this.heightOfPage);
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final cart = cartData.cart;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: heightOfPage * 0.9,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                value: cart.values.toList()[index],
                child: EachCartItem(cart.keys.toList()[index]),
              );
            },
            itemCount: cart.length,
          ),
        ),
        OrderButton(cartData: cartData, heightOfPage: heightOfPage)
      ],
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
    @required this.heightOfPage,
  }) : super(key: key);

  final Cart cartData;
  final double heightOfPage;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.cartData.totalPrice == 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = !isLoading;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrders(
                    widget.cartData.cart.values.toList(),
                    widget.cartData.totalPrice);
                widget.cartData.clear();
                Navigator.of(context).pop();
              } catch (_) {
                await showDialog<Null>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Something went wrong! Try later'),
                      title: Text(
                        "Error",
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              }
              setState(() {
                isLoading = !isLoading;
              });
            },
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
              Colors.orange,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        width: double.infinity,
        height: widget.heightOfPage * 0.1,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(backgroundColor: Colors.white,)
              : Text(
                  "Pay ₹${widget.cartData.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

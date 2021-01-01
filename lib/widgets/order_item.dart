import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/providers/order.dart';

class EachOrderItem extends StatefulWidget {
  final OrderItem orderItem;
  EachOrderItem(this.orderItem);

  @override
  _EachOrderItemState createState() => _EachOrderItemState();
}

class _EachOrderItemState extends State<EachOrderItem> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isExpand ? 105 + widget.orderItem.cartItem.length * 60.0 : 105,
      curve: Curves.easeIn,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "₹${widget.orderItem.totalAmount}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(DateFormat('hh:mm - MMM d, yyyy')
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                  icon: isExpand
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
                  onPressed: () => setState(() {
                        isExpand = !isExpand;
                      })),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpand ? widget.orderItem.cartItem.length * 60.0 : 0,
              child: ListView(
                children: widget.orderItem.cartItem.map((cartItem) {
                  //print(cartItem.)
                  return ListTile(
                    title: Text(
                      cartItem.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${cartItem.quantity}x"),
                        Text(
                          " ₹${cartItem.price}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

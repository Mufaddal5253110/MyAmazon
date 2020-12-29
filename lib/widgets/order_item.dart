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
    return Card(
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
          if (isExpand)
            Container(
              height: widget.orderItem.cartItem.length * 60.0,
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
    );
  }
}

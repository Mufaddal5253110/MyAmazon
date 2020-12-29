import 'package:flutter/material.dart';

import '../widgets/cart_list.dart';

class CartOverview extends StatelessWidget {
  static const routeName = '/cart-overview';
  @override
  Widget build(BuildContext context) {
    print("Cart Build");
    final mQ = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text("My Cart",style: Theme.of(context).textTheme.title,),
    );
    final heightOfPage =
        mQ.size.height - appBar.preferredSize.height - mQ.padding.top;
    final cartCount = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: appBar,
      body: cartCount == 0
          ? Center(
              child: Text(
                "Your Cart is empty!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : CartList(heightOfPage),
    );
  }
}

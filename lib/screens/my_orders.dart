import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/order_item.dart';
import '../providers/order.dart';

class MyOrders extends StatefulWidget {
  static const routeName = '/my-orders';

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  Future _futureOrder;

  Future _gettingFutureOrders() {
    return Provider.of<Orders>(context, listen: false).getOrders();
  }

  @override
  void initState() {
    _futureOrder = _gettingFutureOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    print("Order Build");
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Orders",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        body: FutureBuilder(
          future: _futureOrder,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("Some error occured, Try again later"),
                );
              } else {
                return Consumer<Orders>(builder: (context, ordersData, child) {
                  return ordersData.ordres.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            //print(ordersData.ordres[index].cartItem);
                            return EachOrderItem(ordersData.ordres[index]);
                          },
                          itemCount: ordersData.ordres.length,
                        )
                      : Center(
                          child: Text(
                            "No Data Found!",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        );
                });
              }
            }
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import '../providers/product.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    String productId = ModalRoute.of(context).settings.arguments;
    Product product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    // final appBar = AppBar(
    //   title: Text(
    //     product.title,
    //     style: Theme.of(context).textTheme.title,
    //   ),
    // );
    final mQ = MediaQuery.of(context);
    final heightOfPage =
        mQ.size.height - mQ.padding.top; //-appBar.preferredSize.height ;

    return Scaffold(
      // appBar: appBar,
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: mQ.padding.top),
            width: double.infinity,
            height: heightOfPage,
            child: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.fill,
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
          ),
          Positioned(
            left: mQ.size.width * 0.05,
            bottom: 0.0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              height: isExpand ? heightOfPage * 0.5 : 90,
              width: mQ.size.width * 0.9,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${product.price}",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: isExpand
                                ? Icon(
                                    Icons.expand_more,
                                    size: 40,
                                  )
                                : Icon(
                                    Icons.expand_less,
                                    size: 40,
                                  ),
                            onPressed: () => setState(() {
                              isExpand = !isExpand;
                            }),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        height: isExpand ? heightOfPage * 0.35 : 0,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          children: <Widget>[
                            Text(
                              "${product.title}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${product.description}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

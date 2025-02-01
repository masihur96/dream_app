import 'package:dream_app/models/product_model.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class DetailsScreen extends StatefulWidget {
  final ProductModel product;
  DetailsScreen({required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Body(product: widget.product),
    );
  }
}

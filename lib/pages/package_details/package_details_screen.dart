import 'package:dream_app/models/package_model.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class PackageDetailsScreen extends StatefulWidget {
  final PackageModel product;

  final bool sold;
  PackageDetailsScreen({required this.product, required this.sold});

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Packege Details",
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Body(
        product: widget.product,
        sold: widget.sold,
      ),
    );
  }
}

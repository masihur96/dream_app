import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_app/models/package_model.dart';
import 'package:dream_app/pages/package_details/package_details_screen.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:flutter/material.dart';

class PackageCard extends StatefulWidget {
  const PackageCard({required this.product, required this.sold});
  final PackageModel product;
  final bool sold;

  @override
  _PackageCardState createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PackageDetailsScreen(
                      product: widget.product,
                      sold: widget.sold,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: size.width * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                ),
                child: widget.product.image != null
                    ? Hero(
                        tag: widget.product.id.toString(),
                        child: CachedNetworkImage(
                          imageUrl: widget.product.thumbNail!,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          fit: BoxFit.cover,
                        ))
                    : Container(),
              ),
            ),
            
            // Content Section
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.product.title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Price
                  Text(
                    '৳${widget.product.price}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  
                  // Status (if sold)
                  if (widget.sold && widget.product.status != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.product.status!,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  // Size and Color Section
                  if (widget.product.size!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Text(
                            "Size: ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: widget.product.size!
                                  .take(3)
                                  .map((size) => Padding(
                                        padding: EdgeInsets.only(right: 4),
                                        child: Text(
                                          size,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  if (widget.product.colors!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Text(
                            "Color: ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Row(
                            children: widget.product.colors!
                                .take(4)
                                .map((color) => Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(color)),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
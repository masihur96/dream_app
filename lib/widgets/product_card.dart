import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_app/models/product_model.dart';
import 'package:dream_app/pages/details/details_screen.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
  });
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 8)),
      child: SizedBox(
        width: getProportionateScreenWidth(context, 140),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsScreen(product: product)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF19B52B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            getProportionateScreenWidth(context, 20)),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: product.thumbNail != null
                            ? Hero(
                                tag: product.id.toString(),
                                child: CachedNetworkImage(
                                  imageUrl: product.thumbNail!,
                                  placeholder: (context, url) => CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: size.width * .08,
                                      backgroundImage: AssetImage(
                                          'assets/images/placeholder.png')),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ))
                            : Container(height: 25),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 2.0, right: 2.0),
                      //   child: Icon(
                      //     Icons.add_circle_outline,
                      //     color: kPrimaryColor,
                      //   ),
                      // )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 3),
                    child: Text(
                      product.title!,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, left: 3, bottom: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "\৳${product.price}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Text(
                        //   "\$${product.price}",
                        //   style: TextStyle(
                        //     decoration: TextDecoration.lineThrough,
                        //     fontSize:
                        //         getProportionateScreenWidth(context, 12),
                        //     fontWeight: FontWeight.w300,
                        //     color: Colors.grey[600],
                        //   ),
                        // ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

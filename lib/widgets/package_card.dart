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
  // List selectedColor=[];
  // List selectedSize=[];
  // List <Color> colors =<Color>[Colors.green, Colors.red,Colors.greenAccent,];
  // List <String> productSizes=['S','M','L'];
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
      child: Column(
        children: [
          Card(
            // color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: size.width * .53,
                    decoration: BoxDecoration(
                        //color: Colors.green.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: widget.product.image != null
                        ? Hero(
                            tag: widget.product.id.toString(),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.thumbNail!,
                              placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: size.width * .2,
                                  backgroundImage: AssetImage(
                                      'assets/images/placeholder.png')),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ))
                        : Container(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * .02,
                    left: size.width * .02,
                    right: size.width * .01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: size.width * .24,
                          child: Text(
                            widget.product.title!,
                            style: Theme.of(context).textTheme.titleSmall,
                            // style: TextStyle(color: Colors.black),
                          )),
                      Column(
                        children: [
                          Text(
                            '\৳${widget.product.price}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                widget.sold == false
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(left: size.width * .02),
                              child: Text(
                                widget.product.status!,
                                style: TextStyle(color: kPrimaryColor),
                              )),
                        ],
                      ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.width * .02,
                      left: size.width * .02,
                      right: size.width * .02,
                      bottom: size.width * .02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.width * .07,
                        child: Row(
                          children: [
                            Text("Size: ",
                                style: Theme.of(context).textTheme.titleSmall!),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.product.size!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      widget.product.size![index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 13),
                                    )
                                    // Container(
                                    //     height: size.width*.05,
                                    //     width: size.width*.05,
                                    //     decoration: BoxDecoration(
                                    //         shape: BoxShape.circle,
                                    //         border: Border.all(width: 1,color:Colors.grey)
                                    //     ),
                                    //
                                    //     child: Center(child: Text(widget.product.size![index]))),
                                    //***
                                    // onTap: (){
                                    //
                                    //   if(selectedSize.contains(index)){
                                    //     setState(() {
                                    //       selectedSize.remove(index);
                                    //     });
                                    //
                                    //   }else {
                                    //     setState(() {
                                    //       selectedSize.add(index);
                                    //     });
                                    //   }
                                    // },
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.width * .07,
                        child: Row(
                          children: [
                            Text(
                              "Color: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 13),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.product.colors!.length,
                              itemBuilder: (context, index) {
                                return Icon(Icons.circle_outlined,
                                    size: 15,
                                    color: Color(int.parse(
                                        widget.product.colors![index])));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

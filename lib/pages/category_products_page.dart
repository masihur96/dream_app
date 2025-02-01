import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../home_nav.dart';

class CategoryProductsPage extends StatefulWidget {
  // String? category;
  //
  //
  // CategoryProductsPage(this.category);

  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  int count = 0;
  bool _isLoading = false;
  bool _isLoading1 = false;
  TabController? _controller;
  int _tabIndex = 0;
  int subIndex = 0;

  // Future<void> fetch(ProductController productController)async {
  //   setState(() {
  //     count++;
  //   });
  //   await productController.getCategoryProducts(widget.category!).then((value){
  //     setState(() {
  //       _isLoading=false;
  //     });
  //   });
  // }
  void clear(ProductController productController) {
    setState(() {
      _isLoading = false;
    });
    productController.categoryProductList.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final Size size = MediaQuery.of(context).size;
    // if(count==0){
    //   fetch(productController);
    // }
    return DefaultTabController(
      length: productController.categoryList == null
          ? 0
          : productController.categoryList.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(() => HomeNav());
            },
          ),
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.titleSmall,
            labelColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            unselectedLabelColor: Colors.green,
            onTap: (covariant) async {
              setState(() {
                subIndex = 0;
                _tabIndex = covariant;
                _isLoading = true;
              });
              await productController
                  .getSubCategory(
                      productController.categoryList[_tabIndex].category)
                  .then((value) async {
                productController.subCategoryList.isNotEmpty
                    ? await productController
                        .getSubCategoryProducts(
                            productController.subCategoryList[0].subCategory)
                        .then((value) {
                        setState(() {
                          _isLoading = false;
                        });
                      })
                    : clear(productController);
              });
              // if (_tabIndex != 0) {
              //   apiProvider.updateSubCategoryList(
              //       apiProvider.mainCategoryList[_tabIndex]);
              //
              //   ///Get Category Product
              //   // String categoryId;
              //   // setState(() => _isLoading = true);
              //   // for (int i = 0;
              //   // i < productController.c.length;
              //   // i++) {
              //   //   if (apiProvider.mainCategoryWithId[i].main ==
              //   //       apiProvider.mainCategoryList[_tabIndex]) {
              //   //     categoryId = apiProvider
              //   //         .mainCategoryWithId[i].id
              //   //         .toString();
              //   //   }
              //   // }
              //   Map map = {
              //     "category_id": "$categoryId",
              //     "fetch_scope": "main"
              //   };
              //   // print(categoryId);
              //   await apiProvider
              //       .getCategoryProducts(map)
              //       .then((value) {
              //     setState(() => _isLoading = false);
              //   });
              // }
            },
            isScrollable: true,
            controller: _controller,
            indicator: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 3.5,
              color: kPrimaryColor,
            ))),
            indicatorColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.label,
            physics: BouncingScrollPhysics(),
            tabs: categoryWidgetList(productController),
          ),
          title: Text(
            'Categories',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: _isLoading
            ? Center(child: CupertinoActivityIndicator())
            : Container(
                height: size.height,
                width: size.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///SideBar
                    Container(
                      width: size.width * .24,
                      color: Colors.blueGrey.shade200,
                      child: ListView.builder(
                        itemCount: productController.subCategoryList == null
                            ? 0
                            : productController.subCategoryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                _isLoading1 = true;
                                subIndex = index;
                              });
                              await productController
                                  .getSubCategoryProducts(productController
                                      .subCategoryList[subIndex].subCategory)
                                  .then((value) {
                                setState(() {
                                  _isLoading1 = false;
                                });
                              });
                            },
                            child: Container(
                              color: index == subIndex
                                  ? kPrimaryColor
                                  : Colors.blueGrey.shade200,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '${productController.subCategoryList[index].subCategory}',
                                style: TextStyle(
                                  fontSize: size.width * .03,
                                  fontWeight: index == subIndex
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: index == subIndex
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    ///Main Page Section
                    Container(
                      width: size.width * .74,
                      child: _isLoading1
                          ? Center(child: CupertinoActivityIndicator())
                          : productController.categoryProductList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0, top: 14.0),
                                  child: MasonryGridView.count(
                                    shrinkWrap: true,
                                    physics: new ClampingScrollPhysics(),
                                    itemCount: productController
                                        .categoryProductList.length,
                                    crossAxisCount: 2,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // if (demoProducts[index].isPopular)
                                      return ProductCard(
                                          product: productController
                                              .categoryProductList[index]);
                                      // return SizedBox
                                      //     .shrink(); // here by default width and height is 0
                                    },
                                    mainAxisSpacing: 15.0,
                                  ),
                                )
                              : Center(child: Text('No Products')),
                    ),
                  ],
                ),
              ), //CustomBottomNavBar(selectedMenu: MenuState.home),
      ),
    );
  }

  static List<Widget> categoryWidgetList(ProductController dataProvider) {
    List<Widget> categoryList = dataProvider.categoryList
        .map<Widget>((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                item.category,
              ),
            ))
        .toList();
    return categoryList;
  }
}

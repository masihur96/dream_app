import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream_app/bottom_navigation_bar/cart_page.dart';

import 'package:dream_app/controller/product_controller.dart';
import 'package:dream_app/controller/supabase_storage_service.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/pages/category_products_page.dart';
import 'package:dream_app/pages/contact_info.dart';
import 'package:dream_app/pages/details/details_screen.dart';
import 'package:dream_app/pages/login_page.dart';
import 'package:dream_app/pages/watch_video_page.dart';
import 'package:dream_app/variables/constants.dart';
import 'package:dream_app/variables/size_config.dart';
import 'package:dream_app/widgets/icon_btn_with_counter.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:dream_app/widgets/search_field.dart';
import 'package:dream_app/widgets/solid_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home_nav.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final UserController userController = Get.find<UserController>();
  final ProductController productController = Get.find<ProductController>();
  String? id;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.get('id') as String?;
      //pass = preferences.get('pass');
    });
  }

  final SupabaseStorageService _storageService = SupabaseStorageService();
  final ImagePicker _picker = ImagePicker();
  String? _downloadLink;
  File? _pickedFile;

  Future<void> _uploadFile(BuildContext context) async {
    try {
      // Pick an image from the gallery
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No file selected")),
        );
        return;
      }



      // Convert XFile to File
      final file = File(pickedFile.path);



      // Upload the file to Supabase Storage
      final downloadLink = await _storageService.uploadFile(file, 'my_bucket');


      print("DDDDD: $downloadLink");
      setState(() {
        _downloadLink = downloadLink;
        _pickedFile = file; // Store the picked file for display
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _checkPreferences();

  }



  Future<void> fetch() async {
    await productController.getProducts(_itemCount);
    await productController.getArea();
    await productController.getPackage();
    await userController.getProductOrder();
    await userController.getRate();
    await productController.getCategory();
    await productController.getAreaHub(productController.areaList[0].id);
    await productController.getCategory();
    await productController
        .getSubCategory(productController.categoryList[0].category);
    await productController.getSubCategoryProducts(
        productController.subCategoryList[0].subCategory);
  }

  Future<void> fetch1() async {
    if (productController.categoryList.isEmpty)
      await productController.getCategory();
    if (productController.categoryList.isNotEmpty)
      await productController
          .getSubCategory(productController.categoryList[0].category);
    if (productController.subCategoryList.isNotEmpty)
      await productController.getSubCategoryProducts(
          productController.subCategoryList[0].subCategory);
    if (userController.storePackageList.isEmpty)
      await userController.getMyStore();
    if (userController.productOrderList.isEmpty)
      await userController.getProductOrder();
    if (productController.packageList.isEmpty)
      await productController.getPackage();
    if (userController.infoList.isEmpty) await userController.getContactInfo();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _itemCount = 100;

  void _onRefresh() async {
    _itemCount = 100;
    await productController.getProducts(_itemCount);
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _itemCount = _itemCount + 100;
    print('Item: $_itemCount');
    await productController.getProducts(_itemCount);
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }
  saveNote()async{
    await Supabase.instance.client.from("notes").insert({"body":"textController.text"});
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    fetch1();
    return Obx(() => Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              // Drawer Header with User Profile
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/icons/dream.png", fit: BoxFit.cover),
                ),
                accountName: Text(
                  id != null ? userController.userModel.value.name ?? "Guest User" : "Guest User",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(
                  id != null ? userController.userModel.value.email ?? "" : "Please login to continue",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              
              // Drawer Body - Scrollable List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Home
                    ListTile(
                      leading: Icon(Icons.home_outlined),
                      title: Text('Home', style: Theme.of(context).textTheme.titleMedium),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    
                    // Categories
                    ListTile(
                      leading: Icon(Icons.category_outlined),
                      title: Text('Categories', style: Theme.of(context).textTheme.titleMedium),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.to(() => CategoryProductsPage());
                      },
                    ),
                    
                    // Contact Info
                    ListTile(
                      leading: Icon(Icons.contact_support_outlined),
                      title: Text('Contact Info', style: Theme.of(context).textTheme.titleMedium),
                      onTap: () {
                        Get.to(() => ContactInfo());
                      },
                    ),

                    // Upload Media
                    ListTile(
                      leading: Icon(Icons.upload_outlined),
                      title: Text('Upload Media', style: Theme.of(context).textTheme.titleMedium),
                      onTap: () {
                        _uploadFile(context);
                      },
                    ),

                    Divider(),

                    // Authentication
                    id == null
                        ? ListTile(
                            leading: Icon(Icons.login),
                            title: Text('Login', style: Theme.of(context).textTheme.titleMedium),
                            onTap: () {
                              Get.to(() => LoginPage());
                            },
                          )
                        : ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout', style: Theme.of(context).textTheme.titleMedium),
                            onTap: () async {
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              pref.clear();
                              userController.clear();
                              Get.offAll(() => const HomeNav());
                              showToast('Logged Out');
                            },
                          ),
                  ],
                ),
              ),
              
              // Bottom Section with App Version
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchField(),
            )),
            SizedBox(width: 1),
            Center(
              child: IconBtnWithCounter(
                  icon: Icons.video_camera_back,
                  numOfitem: 0,
                  press: () async{
                    SharedPreferences preference =
                        await SharedPreferences.getInstance();
                    String? wd = preference.getString("advertisementDate");
                    print(wd);

                    id == null
                        ? showToast('Please log in first')
                        : userController.userModel.value.watchDate == wd
                        ? _showDialog()
                        : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WatchVideo()));

                  }),
            ),
            SizedBox(width: 1),
            Center(
              child: IconBtnWithCounter(
                  icon: Icons.shopping_cart,
                  numOfitem: id == null
                      ? productController.cartList == null
                          ? 0
                          : productController.cartList.length
                      : userController.cartList == null
                          ? 0
                          : userController.cartList.length,
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  }),
            ),
            SizedBox(width: 3),
          ],
        ),
        body: _bodyUI(
            context, size) //CustomBottomNavBar(selectedMenu: MenuState.home),
        ));
  }

  Widget _bodyUI(BuildContext context, Size size) {
    final Size size = MediaQuery.of(context).size;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(waterDropColor: Colors.green),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        shrinkWrap: true,
        children: [
          //SizedBox(height: getProportionateScreenWidth(context,10)),
          // GestureDetector(
          //   onTap: () async {
          //     SharedPreferences preference =
          //         await SharedPreferences.getInstance();
          //     String? wd = preference.getString("advertisementDate");
          //
          //     print(wd);
          //     print(userController.userModel.value.watchDate);
          //     id == null
          //         ? showToast('Please log in first')
          //         : userController.userModel.value.watchDate == wd
          //             ? _showDialog()
          //             : Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => WatchVideo()));
          //   },
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Container(
          //         margin: EdgeInsets.symmetric(horizontal: 8.0),
          //         height: 170,
          //         width: size.width,
          //         decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
          //             image: DecorationImage(
          //                 image: AssetImage('assets/images/watch_1.jpg'),
          //                 fit: BoxFit.fill)),
          //         child: Padding(
          //           padding: const EdgeInsets.only(left: 18.0),
          //           child: Align(
          //             alignment: Alignment.centerLeft,
          //             child: Text("Daily Watch video\n&\nEarn Money",
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.white,
          //                   fontSize: 20
          //                 ),
          //               textAlign: TextAlign.center,
          //
          //             ),
          //           ),
          //         ),
          //       ),
          //       Positioned(
          //         bottom: 10.0,
          //         right: 20.0,
          //         child: SolidColorButton(
          //             onPressed: () async {
          //
          //             },
          //             borderRadius: 5.0,
          //             height: size.width * .06,
          //             width: size.width * .3,
          //             bgColor: Colors.white,
          //             child: const Text('Watch Now',
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     color: Colors.black))),
          //       )
          //     ],
          //   ),
          // ),
          SizedBox(height: 10),

          productController.productList.isEmpty
              ? Lottie.asset('assets/images/empty_place_holder.json')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: productController.categoryList.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = productController.categoryList[categoryIndex].category;
                    final categoryProducts = productController.productList
                        .where((product) => product.category == category)
                        .toList();

                    return categoryProducts.isEmpty
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 280,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryProducts.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailsScreen(
                                                product: categoryProducts[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 160,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF19B52B).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 160,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(15),
                                                  ),
                                                ),
                                                child: categoryProducts[index].image != null
                                                    ? Hero(
                                                        tag: categoryProducts[index].id.toString(),
                                                        child: CachedNetworkImage(
                                                          imageUrl: categoryProducts[index].thumbNail,
                                                          placeholder: (context, url) => CircleAvatar(
                                                            backgroundColor: Colors.grey.shade200,
                                                            backgroundImage: AssetImage(
                                                                'assets/images/placeholder.png'),
                                                          ),
                                                          errorWidget: (context, url, error) =>
                                                              Icon(Icons.error),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Container(),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      categoryProducts[index].title!,
                                                      maxLines: 2,
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "৳${categoryProducts[index].price}",
                                                      style: Theme.of(context).textTheme.titleMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                  },
                ),
          //SizedBox(width: getProportionateScreenWidth(20)),
        ],
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Text(
                    'Your video watching limit is over for today.\n'
                    'Please wait for the next day.\nThank you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          //Navigator.of(context).pop();
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

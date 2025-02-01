import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_app/controller/user_controller.dart';
import 'package:dream_app/models/Cart.dart';
import 'package:dream_app/models/area_hub_model.dart';
import 'package:dream_app/models/category_model.dart';
import 'package:dream_app/models/package_model.dart';
import 'package:dream_app/models/product_model.dart';
import 'package:dream_app/models/sub_category_model.dart';
import 'package:dream_app/widgets/notification_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  RxInt total = 0.obs;
  RxInt totalProfitAmount = 0.obs;
  RxList<ProductModel> _productList = RxList<ProductModel>([]);
  RxList<Cart> _cartList = RxList<Cart>([]);
  RxList<CategoryModel> _categoryList = RxList<CategoryModel>([]);
  RxList<ProductModel> _categoryProductList = RxList<ProductModel>([]);
  RxList<AreaHubModel> _areaList = RxList<AreaHubModel>([]);
  RxList<AreaHubModel> _areaHubList = RxList<AreaHubModel>([]);
  RxList<String> _productIdList = RxList<String>([]);
  String? id;
  String? deviceId;
  RxList<PackageModel> packageList = <PackageModel>[].obs;
  RxList<SubCategoryModel> _subCategoryList = <SubCategoryModel>[].obs;

  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.get('id') as String?;
    deviceId = preferences.get('deviceId') as String?;
  }

  @override // called when you use Get.put before running app
  void onInit() {
    super.onInit();
    _checkPreferences();
  }

  get productList => _productList;
  get cartList => _cartList;
  get categoryList => _categoryList;
  get categoryProductList => _categoryProductList;
  get productIdList => _productIdList;
  get areaList => _areaList;
  get areaHubList => _areaHubList;
  get subCategoryList => _subCategoryList;

  Future<void> getProducts(int limit) async {
    try {
      print('executed');
      await FirebaseFirestore.instance
          .collection('Products')
          .limit(limit)
          .get()
          .then((snapShot) {
        _productList.clear();
        snapShot.docChanges.forEach((element) {
          ProductModel productModel = ProductModel(
            id: element.doc['id'],
            title: element.doc['title'],
            thumbNail: element.doc['thumbnail'],
            description: element.doc['description'],
            price: element.doc['price'],
            profitAmount: element.doc['profitAmount'],
            size: element.doc['size'],
            category: element.doc['category'],
            subCategory: element.doc['subCategory'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
          );
          _productList.add(productModel);
        });
        print(_productList.length);
        update();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> addToCart(
      String productName,
      String thumbnail,
      String productId,
      String price,
      int quantity,
      String color,
      String size,
      String image,
      String profitAmount) async {
    try {
      showLoadingDialog(Get.context!);
      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(deviceId)
          .collection('CartList')
          .doc(productId)
          .set({
        "id": DateTime.now().millisecondsSinceEpoch,
        "productName": productName,
        "productId": productId,
        "productImage": image,
        "thumbnail": thumbnail,
        "price": price,
        "quantity": quantity,
        "color": color,
        "size": size,
        "profitAmount": profitAmount
      }).then((value) async {
        await getCart();
        Get.back();
        showToast('Product added to cart');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getCart() async {
    try {
      await FirebaseFirestore.instance
          .collection('Cart')
          .doc(deviceId)
          .collection('CartList')
          .get()
          .then((snapShot) {
        _cartList.clear();
        _productIdList.clear();
        total = 0.obs;
        totalProfitAmount = 0.obs;
        snapShot.docChanges.forEach((element) {
          Cart cart = Cart(
              id: element.doc['id'],
              productName: element.doc['productName'],
              productId: element.doc['productId'],
              productImage: element.doc['productImage'],
              thumbnail: element.doc['thumbnail'],
              price: element.doc['price'],
              quantity: element.doc['quantity'],
              color: element.doc['color'],
              size: element.doc['size'],
              profitAmount: element.doc['profitAmount']);
          _cartList.add(cart);
          _productIdList.add(cart.productId!);
          total = total + (int.parse(cart.price!) * cart.quantity!);
          totalProfitAmount = totalProfitAmount +
              int.parse(cart.profitAmount!) * cart.quantity!;
        });
        print(total);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateCart(String productId, int quantity) async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance
        .collection('Cart')
        .doc(deviceId)
        .collection('CartList')
        .doc(productId)
        .update({
      "quantity": quantity,
    }).then((value) async {
      await getCart();
      Get.back();
    });
  }

  Future<void> deleteCartItem(String productId) async {
    showLoadingDialog(Get.context!);
    await FirebaseFirestore.instance
        .collection('Cart')
        .doc(deviceId)
        .collection('CartList')
        .doc(productId)
        .delete()
        .then((value) async {
      await getCart();
      Get.back();
      Get.back();
      showToast('Product deleted from cart');
    });
  }

  Future<void> deleteCart() async {
    print('deviceId:$deviceId');
    await FirebaseFirestore.instance
        .collection('Cart')
        .doc(deviceId)
        .collection('CartList')
        .get()
        .then((value) {
      value.docChanges.forEach((element) {
        FirebaseFirestore.instance
            .collection('Cart')
            .doc(deviceId)
            .collection("CartList")
            .doc(element.doc.id)
            .delete();
      });
    });
  }

  Future<void> getArea() async {
    try {
      await FirebaseFirestore.instance
          .collection('Area&Hub')
          .get()
          .then((snapShot) {
        _areaList.clear();
        snapShot.docChanges.forEach((element) {
          AreaHubModel areaHubModel = AreaHubModel(
            hub: element.doc['hub'],
            id: element.doc['id'],
          );
          _areaList.add(areaHubModel);
        });
        print('Area List${_areaList.length}');
      });
      getAreaHub(_areaList.first.id!);
    } catch (error) {
      print(error);
    }
  }

  Future<void> getAreaHub(String area) async {
    try {
      await FirebaseFirestore.instance
          .collection('Area&Hub')
          .where('id', isEqualTo: area)
          .get()
          .then((snapShot) {
        _areaHubList.clear();
        snapShot.docChanges.forEach((element) {
          print("element: ${element.doc['hub']}");
          AreaHubModel areaHubModel = AreaHubModel(
            hub: element.doc['hub'],
            id: element.doc['id'],
          );
          _areaHubList.add(areaHubModel);
        });
        print('Hub List${_areaHubList.length}');
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> createOrder(
      String name,
      String phone,
      String unique,
      String area,
      String hub,
      String quantity,
      String totalAmount,
      List<dynamic> cartModel,
      UserController userController) async {
    Map<String, dynamic> orderData = {
      "id": unique, // replace 'unique' with the actual unique identifier
      "name": name, // replace 'name' with the actual name variable
      "phone": phone, // replace 'phone' with the actual phone variable
      "orderNumber": '${DateTime.now().millisecondsSinceEpoch}',
      "orderDate": DateFormat('yyyy/MM/dd hh:mm:ss').format(DateTime.now()),
      "state": 'pending',
      "Area": area, // replace 'area' with the actual area variable
      "hub": hub, // replace 'hub' with the actual hub variable
      "quantity":
          quantity, // replace 'quantity' with the actual quantity variable
      "totalAmount":
          totalAmount, // replace 'totalAmount' with the actual total amount variable
      "products": FieldValue.arrayUnion(
          cartModel) // replace 'cartModel' with the actual cart model variable
    };

    print(orderData);

    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(unique)
        .set(orderData)
        .then((value) async {
      id == null ? await deleteCart() : await userController.deleteUserCart();
      await userController.getProductOrder();
    });
  }

  Future<void> getPackage() async {
    try {
      await FirebaseFirestore.instance
          .collection('Packages')
          .orderBy('title')
          .get()
          .then((snapShot) {
        packageList.clear();
        snapShot.docChanges.forEach((element) {
          PackageModel packageModel = PackageModel(
              id: element.doc['id'],
              title: element.doc['title'],
              description: element.doc['description'],
              thumbNail: element.doc['thumbnail'],
              price: element.doc['price'],
              quantity: element.doc['quantity'],
              size: element.doc['size'],
              colors: element.doc['colors'],
              image: element.doc['image'],
              date: element.doc['date'],
              discountAmount: element.doc['discountAmount']);
          packageList.add(packageModel);
        });
        print('Package List: ${packageList.length}');
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getCategory() async {
    try {
      await FirebaseFirestore.instance
          .collection('Category')
          .get()
          .then((snapShot) {
        _categoryList.clear();
        snapShot.docChanges.forEach((element) {
          CategoryModel category = CategoryModel(
            category: element.doc['category'],
            id: element.doc['id'],
          );
          _categoryList.add(category);
        });
        print('Category List: ${_categoryList.length}');
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getSubCategory(String cat) async {
    try {
      await FirebaseFirestore.instance
          .collection('SubCategory')
          .where('category', isEqualTo: cat)
          .get()
          .then((snapShot) {
        _subCategoryList.clear();
        snapShot.docChanges.forEach((element) {
          SubCategoryModel subCategory = SubCategoryModel(
            subCategory: element.doc['subCategory'],
            id: element.doc['id'],
            category: element.doc['category'],
          );
          _subCategoryList.add(subCategory);
        });
        print('SubCategory: ${_subCategoryList.length}');
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> getSubCategoryProducts(String subCat) async {
    try {
      await FirebaseFirestore.instance
          .collection('Products')
          .where('subCategory', isEqualTo: subCat)
          .get()
          .then((snapShot) {
        _categoryProductList.clear();
        snapShot.docChanges.forEach((element) {
          ProductModel productModel = ProductModel(
            id: element.doc['id'],
            title: element.doc['title'],
            description: element.doc['description'],
            thumbNail: element.doc['thumbnail'],
            price: element.doc['price'],
            profitAmount: element.doc['profitAmount'],
            size: element.doc['size'],
            category: element.doc['category'],
            subCategory: element.doc['subCategory'],
            colors: element.doc['colors'],
            image: element.doc['image'],
            date: element.doc['date'],
          );
          _categoryProductList.add(productModel);
        });
        print(_categoryProductList.length);
      });
    } catch (error) {
      print(error);
    }
  }
}

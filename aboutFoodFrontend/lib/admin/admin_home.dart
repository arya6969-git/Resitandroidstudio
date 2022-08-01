import 'package:movieflix/admin/add_product.dart';
import 'package:movieflix/admin/product_details.dart';
import 'package:movieflix/admin/search_page.dart';
import 'package:movieflix/admin/update_product_scree.dart';
import 'package:movieflix/admin/view_my_order.dart';
import 'package:movieflix/admin/view_order.dart';
import 'package:movieflix/model/product.dart';
import 'package:movieflix/screen/login_screen.dart';
import 'package:movieflix/services/delete_product_api.dart';
import 'package:movieflix/services/product_service.dart';
import 'package:movieflix/services/searchProduct_api.dart';
import 'package:movieflix/utils/configs.dart';
import 'package:movieflix/utils/search.dart';
import 'package:movieflix/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MyProduct>(context, listen: false).getproduct(context);
  }

  late List<ProductElement>? products;
  String query = '';
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/logo.png"))),
                child: Stack(children: const [])),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: Color.fromARGB(255, 226, 145, 202),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  primary: Color.fromARGB(255, 226, 145, 202),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddProductUi()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add Product",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 240, 96, 144),
              thickness: 1,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: Color.fromARGB(255, 226, 145, 202),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  primary: Color.fromARGB(255, 226, 145, 202),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ViewAdminOrders()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "View All Orders",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 240, 96, 144),
              thickness: 1,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              color: Color.fromARGB(255, 226, 145, 202),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  primary: Color.fromARGB(255, 226, 145, 202),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ViewMyOrder()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_red_eye_sharp,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "View My Order",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 240, 96, 144),
              thickness: 1,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  SharedServices.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                    (route) => false,
                  );
                  Fluttertoast.showToast(
                    msg: "Successfully Logged Out",
                    toastLength: Toast.LENGTH_LONG,
                    fontSize: 12,
                    textColor: Colors.black,
                    backgroundColor: Colors.grey[100],
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Color.fromARGB(255, 226, 145, 202),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 226, 145, 202),
        title: const Text(
          "Admin Dashboard",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          )
        ],
      ),
      body: Consumer<MyProduct>(builder: (context, product, child) {
        if (product.value?.isEmpty == true) {
          return Center(
              child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(20), child: const Text("Empty")),
          ));
        } else {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Color.fromARGB(255, 243, 134, 247),
                    Color.fromARGB(255, 164, 84, 167),
                  ])),
              child: Container(
                margin: const EdgeInsets.all(15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: product.value?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridTile(
                        child: InkWell(
                          onTap: () {
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                          id: (product.value?[index].id)
                                              .toString(),
                                          name: (product.value?[index].name)
                                              .toString(),
                                          image: (product.value?[index].image)
                                              .toString(),
                                          category:
                                              (product.value?[index].category)
                                                  .toString(),
                                          price: (product.value?[index].price)!
                                              .toInt(),
                                          description: (product
                                                  .value?[index].description)
                                              .toString(),
                                          productid: (product.value?[index].id)
                                              .toString(),
                                          stock: ((product
                                                  .value?[index].countInStock)
                                              .toString()),
                                        )),
                              );
                            }
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(Configs.mainURL +
                                      "/uploads/" +
                                      "${product.value?[index].image}"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        footer: Column(
                          children: [
                            Text((product.value?[index].name).toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 243, 241, 242),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            space(),
                            Text(
                                "\$: ${(product.value?[index].price).toString()}",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 253, 253, 253),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            space(),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          );
        }
      }),
    );
  }

  SizedBox space() {
    return const SizedBox(
      height: 5,
    );
  }
}

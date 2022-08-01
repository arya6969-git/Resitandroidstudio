import 'package:movieflix/admin/search_page.dart';
import 'package:movieflix/admin/view_my_order.dart';
import 'package:movieflix/model/product.dart';
import 'package:movieflix/screen/login_screen.dart';
import 'package:movieflix/screen/productuserdetail.dart';
import 'package:movieflix/screen/searchuserpage.dart';
import 'package:movieflix/services/product_service.dart';
import 'package:movieflix/utils/configs.dart';
import 'package:movieflix/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ViewMyOrder()),
                );
              },
              child: Text(
                "View My Order",
                style: TextStyle(color: Color.fromARGB(255, 226, 145, 202)),
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 226, 145, 202),
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
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 241, 134, 245),
        title: const Text("About Food"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUserPage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromARGB(255, 243, 125, 223),
                Color.fromARGB(255, 235, 137, 235),
              ])),
          child: Consumer<MyProduct>(builder: (context, product, child) {
            if (product.value?.isEmpty == true) {
              return Center(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text("Empty")));
            } else {
              return SingleChildScrollView(
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
                                      builder: (context) => ProductUserDetail(
                                            id: (product.value?[index].id)
                                                .toString(),
                                            name: (product.value?[index].name)
                                                .toString(),
                                            image:
                                                (product.value?[index].image),
                                            category:
                                                (product.value?[index].category)
                                                    .toString(),
                                            price:
                                                (product.value?[index].price)!
                                                    .toInt(),
                                            description: (product
                                                    .value?[index].description)
                                                .toString(),
                                            productid:
                                                (product.value?[index].id)
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
                                      color: Color.fromARGB(255, 252, 249, 251),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              space(),
                              Text(
                                  "\$: ${(product.value?[index].price).toString()}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 252, 250, 252),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              space(),
                            ],
                          ),
                        );
                      }),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  SizedBox space() {
    return const SizedBox(
      height: 5,
    );
  }
}

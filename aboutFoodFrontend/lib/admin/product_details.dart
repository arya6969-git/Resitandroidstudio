import 'dart:io';
import 'package:movieflix/admin/admin_home.dart';
import 'package:movieflix/admin/update_product_scree.dart';
import 'package:movieflix/services/product_service.dart';
import 'package:movieflix/services/rent_api.dart';
import 'package:movieflix/services/searchProduct_api.dart';
import 'package:movieflix/utils/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:movieflix/utils/configs.dart';

class ProductDetail extends StatefulWidget {
  final String id;
  final String name;
  final dynamic image;
  final String category;
  final int price;
  final String description;
  final String productid;
  final String stock;

  const ProductDetail({
    Key? key,
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.productid,
    required this.image,
    required this.stock,
  }) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final address = TextEditingController();
  final city = TextEditingController();
  final postalCode = TextEditingController();
  final country = TextEditingController();
  TextEditingController dateInText = TextEditingController();
  TextEditingController dateOutText = TextEditingController();
  final GlobalKey<FormState> globalCompleteFormKey = GlobalKey<FormState>();

  DateTimeRange? dateRange;
  String getFrom() {
    if (dateRange == null) {
      return "Select Rent Date From";
    } else {
      return DateFormat("yyyy-MM-dd").format(dateRange!.start);
    }
  }

  String getTo() {
    if (dateRange == null) {
      return ("Until *");
    } else {
      return DateFormat("yyyy-MM-dd").format(dateRange!.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeDate = Provider.of<TimeProvider>(context);
    DateTime selectedDateFrom = DateTime.now();
    DateTime selectedDateTo = DateTime.now().add(const Duration(days: 7));
    String durationFrom = timeDate.getDate((selectedDateFrom).toString());
    String durationTo = timeDate.getDate((selectedDateTo).toString());

    Future pickDateRange(BuildContext context) async {
      final initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(hours: 24 * 7)),
      );
      final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: dateRange ?? initialDateRange,
      );
      if (newDateRange == null) return;
      setState(() {
        dateRange = newDateRange;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 156, 230),
        title: const Text("Details"),
        centerTitle: true,
      ),
      body: Consumer<MyProduct>(
        builder: (context, product, child) {
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(8),
              child: Card(
                elevation: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gap(),
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(Configs.mainURL +
                                      "/uploads/" +
                                      "${widget.image}"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                gap(),
                                Text("Food Name : ${widget.name}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 226, 145, 202),
                                      fontSize: 16,
                                    )),
                                gap(),
                                Text("Category: ${widget.category}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 226, 145, 202),
                                      fontSize: 16,
                                    )),
                                gap(),
                                Text("Prices \$: ${widget.price}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 226, 145, 202),
                                      fontSize: 16,
                                    )),
                                gap(),
                                Text("Total Available Food: ${widget.stock}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 226, 145, 202),
                                      fontSize: 16,
                                    )),
                                gap(),
                                Text("Description: ${widget.description}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 226, 145, 202),
                                      fontSize: 16,
                                    )),
                                gap(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            product
                                                .delproduct(
                                                  widget.id,
                                                  context,
                                                )
                                                .then((value) => {
                                                      if (value.message ==
                                                          "Product Removed")
                                                        {
                                                          Navigator.pop(
                                                              context),
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Product Successfully Removed",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            fontSize: 20.0,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            textColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Color.fromARGB(255, 228, 131, 215),
                                                          ),
                                                        }
                                                    });
                                          },
                                          child: const Text("Delete"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 245, 150, 245),
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateProductUi(
                                                  id: widget.id,
                                                  name: widget.name,
                                                  category: widget.category,
                                                  description:
                                                      widget.description,
                                                  stock: widget.stock,
                                                  price:
                                                      widget.price.toString(),
                                                  image: widget.image,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text("Update"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 253, 151, 245),
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                        ),
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
                    gap(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox gap() {
    return const SizedBox(
      height: 20,
    );
  }
}

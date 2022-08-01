import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:movieflix/model/add_product_model.dart';
import 'package:movieflix/services/product_service.dart';
import 'package:movieflix/utils/configs.dart';
import 'package:movieflix/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

Future<dynamic> postproduct(
  String name,
  String category,
  String description,
  String availableVehicle,
  String price,
  dynamic image,
  context,
) async {
  String path = "";
  dynamic imageFile;
  if (image != null) {
    imageFile = MultipartFile.fromFileSync(
      image.path,
      filename: "${image.path.split("/")[image.path.split("/").length - 1]}",
    );
  }

  var stream = new http.ByteStream(image.openRead());
  stream.cast();
  // get file length
  var length = await image.length();
  // string to uri
  var uri = Uri.parse(Configs.upload);
  // create multipart request
  var request = new http.MultipartRequest("POST", uri);
  // multipart that takes file
  var multipartFile = new http.MultipartFile('image', stream, length,
      filename: basename(image.path));

  // String? token = await SharedServices.loginDetails();

  // var headers = {
  //   "Authorization": "Bearer $token",
  //   "Access-Control-Allow-Origin": "/",
  //   "Content-Type": "application/json",
  // };

  // var body = {
  //   "name": name,
  //   "category": category,
  //   "description": description,
  //   "countInStock": availableVehicle,
  //   "price": price,
  //   "image": image != null ? "/${imageFile.filename}" : null,
  // };

  // request.fields.addAll(body);

  // request.headers.addAll(headers);

  // add file to multipart
  request.files.add(multipartFile);

  var response = await request.send();

  await response.stream.transform(utf8.decoder).listen((value) {
    Map<dynamic, dynamic> json = jsonDecode(value);
    path = json["path"];
    print(json["path"]);
  });

  var body = {
    "name": name,
    "category": category,
    "description": description,
    "countInStock": availableVehicle,
    "price": price,
    "image": path != null ? path : null,
  };

  // print(body);

  String? token = await SharedServices.loginDetails();
  var response1 = await http.post(
    Uri.parse(Configs.product),
    headers: {
      "Authorization": "Bearer $token",
      "Access-Control-Allow-Origin": "/",
      "Content-Type": "application/json",
    },
    body: jsonEncode(body),
  );
  if (response1.statusCode == 201) {
    var addProduct = addProductFromJson(response1.body);
    await Provider.of<MyProduct>(context, listen: false).getproduct(context);
    return addProduct;
  } else {
    Fluttertoast.showToast(
      msg: "Error ! \nPlease try again later.",
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 20.0,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.red[800],
    );
  }
}

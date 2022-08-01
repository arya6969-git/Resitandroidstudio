import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Proceed extends StatefulWidget {
  Proceed({Key? key}) : super(key: key);

  @override
  State<Proceed> createState() => _ProceedState();
}

class _ProceedState extends State<Proceed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 226, 145, 202),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 226, 145, 202),
          onPressed: () {},
          elevation: 5,
          icon: const Icon(Icons.done_all),
          label: const Text('Done.'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: InkWell(
          onTap: () {},
        ));
  }
}

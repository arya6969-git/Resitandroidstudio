import 'package:movieflix/screen/car_details.dart';
import 'package:movieflix/screen/homepage.dart';
import 'package:movieflix/screen/login_screen.dart';
import 'package:movieflix/services/cartservices.dart';
import 'package:movieflix/services/get_rent_services.dart';
import 'package:movieflix/services/product_service.dart';
import 'package:movieflix/services/searchProduct_api.dart';
import 'package:movieflix/services/view_my_order_services.dart';
import 'package:movieflix/utils/shared_preference.dart';
import 'package:movieflix/utils/time_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'About Food',
        channelDescription: "Notification example",
        defaultColor: Color.fromARGB(255, 235, 232, 238),
        ledColor: Color.fromARGB(255, 226, 145, 202),
        playSound: true,
        enableLights: true,
        importance: NotificationImportance.High,
        enableVibration: true)
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => MyProduct()),
    ChangeNotifierProvider(create: (_) => TimeProvider()),
    ChangeNotifierProvider(create: (_) => GetAllOrders()),
    ChangeNotifierProvider(create: (_) => SearchProduct()),
    ChangeNotifierProvider(create: (_) => ViewMyOrders()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'About Food',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 226, 145, 202),
      ),
      home: LoginScreen(),
    );
  }
}

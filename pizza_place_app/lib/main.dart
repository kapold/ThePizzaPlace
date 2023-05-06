import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pizza_place_app/pages/AddPizzaPage.dart';
import 'package:pizza_place_app/pages/AddressesPage.dart';
import 'package:pizza_place_app/pages/AdminPage.dart';
import 'package:pizza_place_app/pages/DeliveryManPage.dart';
import 'package:pizza_place_app/pages/HistoryPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pizza_place_app/pages/AuthPage.dart';
import 'package:pizza_place_app/pages/CartPage.dart';
import 'package:pizza_place_app/pages/MenuPage.dart';
import 'package:pizza_place_app/pages/MainPage.dart';
import 'package:pizza_place_app/pages/OrdersPage.dart';
import 'package:pizza_place_app/pages/ProfilePage.dart';
import 'package:pizza_place_app/pages/AboutAppPage.dart';
import 'package:pizza_place_app/pages/RegisterPage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  String? username = prefs.getString('username');
  int? role = prefs.getInt('role');
  String initialRoute = username != "" ? '/main' : '/auth';
  if (role == 1)
    initialRoute = '/main';
  else if (role == 2)
    initialRoute = '/admin';
  else if (role == 3)
    initialRoute = '/deliveryman';
  else
    initialRoute = '/auth';
  print("Initial Route: " + initialRoute);
  runApp(MyApp(initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/register': (context) => const RegisterPage(),
        '/auth': (context) => const AuthPage(),
        '/main': (context) => const MainPage(),
        '/menu': (context) => const MenuPage(),
        '/profile': (context) => const ProfilePage(),
        '/orders': (context) => const OrdersPage(),
        '/cart': (context) => const CartPage(),
        '/aboutApp': (context) => const AboutAppPage(),
        '/addresses': (context) => const AddressesPage(),
        '/history': (context) => const HistoryPage(),
        '/admin': (context) => const AdminPage(),
        '/deliveryman': (context) => const DeliveryManPage(),
        '/add': (context) => const AddPizzaPage()
      },
      theme: ThemeData(
          fontFamily: 'Ubuntu',
          useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
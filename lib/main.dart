
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Screen/Auth_screen/login_screen.dart';
import 'package:serial_managementapp_project/Screen/Auth_screen/registration_screen.dart';
import 'package:serial_managementapp_project/Screen/servicecenter_screen/home_screen.dart';
import 'package:serial_managementapp_project/Widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'package:serial_managementapp_project/Widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import 'package:serial_managementapp_project/providers/auth_providers.dart';
import 'package:serial_managementapp_project/providers/profile_update_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/servicetaker_screen/servicetaker_homescreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  String? userType = prefs.getString('userType');
  String initialRoute;

  if (token == null) {
    initialRoute = '/login';
  } else if (userType == 'customer') {
    initialRoute = '/customerHome';
  } else {
    initialRoute = '/home'; // default to company
  }
  final authProvider = AuthProvider();


  runApp(

      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(),),
        ChangeNotifierProvider(create: (context) => ProfileProvider(),)
      ],
      child:  MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute, });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
     initialRoute:initialRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => CustomServicecenterNavigationbar(), // company
        '/customerHome': (context) => CustomServicetakerNavigationbar(),   // customer
      },
    );
  }
}



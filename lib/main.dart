
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/providers/auth_providers.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_provider.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_serviceType_privider.dart';
import 'package:serial_no_app/providers/getprofile_provider.dart';
import 'package:serial_no_app/providers/password_upadate_provider.dart';
import 'package:serial_no_app/providers/profile_update_provider.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/get_serialServiceCenter_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/Auth_screen/login_screen.dart';
import 'Screen/servicetaker_screen/servicetaker_homescreen.dart';
import 'Widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'Widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';

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
        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) =>Getprofileprovider() ,),
        ChangeNotifierProvider(create: (context) => PasswordUpdateProvider(),),
        ChangeNotifierProvider(create: (context) => GetAddButtonProvider(),),
        ChangeNotifierProvider(create: (context) => GetAddButton_serviceType_Provider(),),
        ChangeNotifierProvider(create: (context) => SerialListProvider(),)

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



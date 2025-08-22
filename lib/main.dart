
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/api/serviceCenter_api/addButton_serviceType/addbutton_serviceType.dart';
import 'package:serialno_app/providers/app_provider/app_provider.dart';
import 'package:serialno_app/providers/auth_provider/auth_providers.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/auth_provider/password_upadate_provider.dart';
import 'package:serialno_app/providers/profile_provider/profile_update_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/add_Button_serviceCanter_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/business_type_provider/business_type_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/company_details_provider/company_details_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButtonServiceType_provider/editButtonServiceType_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButtonServiceType_provider/getEditButtonServiceType_Provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButton_provider/edit_ButtonProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButton_provider/get_EditButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/statusButtonProvider/get_status_updateButtonButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/nextButton_provider/nextButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/statusButtonProvider/status_UpdateButton_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/bookSerialButton_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/ServiceCenterByTypeProvider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/commentCancelButton_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/getBookSerial_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/getCommentCancelButtonProvider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/getUpdate_bookSerial_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/organization_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/serviceCenter_serialBook.dart';
import 'package:serialno_app/providers/serviceTaker_provider/serviceType_serialbook_provider.dart';
import 'package:serialno_app/providers/serviceTaker_provider/update_bookserial_provider.dart';
import 'package:serialno_app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/Auth_screen/login_screen.dart';
import 'Widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import 'Widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('accessToken');
  String? userType = prefs.getString('userType');
  String initialRoute;

  if (token == null) {
    initialRoute =AppRouteNames.login;
  } else if (userType == 'customer') {
    initialRoute = AppRouteNames.customerHome;
  } else {
    initialRoute = AppRouteNames.companyHome;// default to company
  }
  final authProvider = AuthProvider();


  runApp(

      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(),),

        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) =>Getprofileprovider() ,),

        ChangeNotifierProvider(create: (context) => PasswordUpdateProvider(),),

        ChangeNotifierProvider(create: (context) => AddButtonProvider(),),
        ChangeNotifierProvider(create: (context) => GetAddButtonProvider(),),

        ChangeNotifierProvider(create: (context) => EditButtonProvider(),),
        ChangeNotifierProvider(create: (context) => GetEditButtonProvider(),),


        ChangeNotifierProvider(create: (context) => GetAddButtonServiceType_Provider(),),
        ChangeNotifierProvider(create: (context) => AddButtonServiceTypeProvider(),),

        ChangeNotifierProvider(create: (context) => EditButtonServiceTypeProvider(),),
        ChangeNotifierProvider(create: (context) => GetEditButtonServiceTypeProvider(),),


        ChangeNotifierProvider(create: (context) => NewSerialButtonProvider(),),
        ChangeNotifierProvider(create: (context) => GetNewSerialButtonProvider(),),



        ChangeNotifierProvider(create: (context) => getStatusUpdate_Provider(),),
        ChangeNotifierProvider(create: (context) => statusUpdateButton_provder(),),

        ///Next ButtonProvider
        ChangeNotifierProvider(create: (context) => nextButtonProvider(),),

        /// businessType provider optional
        ChangeNotifierProvider(create: (context) => BusinessTypeProvider(),),


        ChangeNotifierProvider(create: (context) => CompanyDetailsProvider(),),
        ///

        ///Organization Provider
        ChangeNotifierProvider(create: (context) => OrganizationProvider(),),

        ///
        ChangeNotifierProvider(create: (context) => serviceTypeSerialbook_Provider(),),


        ///
        ChangeNotifierProvider(create:(context) => RolesProvider(),),




        ChangeNotifierProvider(create: (context) => bookSerialButton_provider(),),
        ChangeNotifierProvider(create: (context) => GetBookSerialProvider(),),

        ///BusinessType Provider
        ChangeNotifierProvider(create: (context) => ServiceCenterByTypeProvider(),),


        ChangeNotifierProvider(create: (context) => UpdateBookSerialProvider(),),
        ChangeNotifierProvider(create: (context) => GetUpdate_bookSerialProvider(),),


        ///CommentCancel Provider
        ChangeNotifierProvider(create: (context) => CommentCancelButtonProvider(),),
        ChangeNotifierProvider(create: (context) => GetCommentCancelButtonProvider(),),

      ],
          child:  MyApp()));
}




class MyApp extends StatelessWidget {

 // final String initialRoute;
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
     // initialRoute:initialRoute,
      routes: AppRouter.routes,


      home: AuthWrapper(),
    );
  }
}


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = Provider.of<AuthProvider>(context, listen: false).loadUserFromToken();

  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }


        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        if (authProvider.accessToken != null) {
          final userType = authProvider.userType?.toLowerCase() ?? '';
          if (userType == 'customer') {
            return const CustomServicetakerNavigationbar();
          } else {
            return const CustomServicecenterNavigationbar();
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
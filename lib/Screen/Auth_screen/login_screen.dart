

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/Screen/Auth_screen/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/Custom_NavigationBar/custom_servicecenter_navigationBar.dart';
import '../../Widgets/Custom_NavigationBar/custom_servicetaker_navigationbar.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../providers/auth_providers.dart';
import '../../services/auth_service.dart';
import '../../utils/color.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMod = AutovalidateMode.disabled;
  final AuthService _authService=AuthService();

  bool obscureIndex=true;
  bool isLoading = false;
  String? _errorMessage;
  TextEditingController loginName = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    loginName.dispose();
    password.dispose();
  }

  //login handle logic
  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      autovalidateMod = AutovalidateMode.always;
      _errorMessage = null;
    });
    if (!_formkey.currentState!.validate()) return;
    setState(() => isLoading = true);

    await authProvider.login(
      loginName: loginName.text,
      password: password.text,
      context: context
    );
    setState(() => isLoading = false);
    if (!mounted) return;
    if (authProvider.accessToken != null) {
      String userType = authProvider.userType?.toLowerCase().trim() ?? "";
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', authProvider.accessToken!);
      await prefs.setString('userType', userType);
      await authProvider.loadUserFromToken();
      print("User Type After Login: $userType");

  await  CustomFlushbar.showSuccess(
      context: context,
      title: "Success",
      message: "Login Successful"
  );

      if (userType == "company") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomServicecenterNavigationbar(),));

      } else if (userType == "customer") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomServicetakerNavigationbar(),));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown User Type${userType}',),
            backgroundColor:Colors.white,
            padding: EdgeInsets.all(20),
            behavior:SnackBarBehavior.floating,
          ),
        );
        }
      }else if (authProvider.errorMessage != null) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            content:CustomSnackBarWidget(
                title: "Error",
                message: "${authProvider.errorMessage??
                    "Login Failed"}"
            )
          )
      );
    };
    }



  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);
    return Form(
      key: _formkey,
      autovalidateMode: autovalidateMod,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/image/1st-removebg-preview.png",height: 250,width: 300,),
                 CustomTextField(
                     hintText: "Login name",
                     isPassword: false,
                     controller: loginName,
                   prefixIcon: Icons.person,
                 ),
                  SizedBox(height: 10,),
                 CustomTextField(
                     hintText: "Password",
                     isPassword: true,
                     controller: password,
                     prefixIcon: Icons.lock
                 ),
                    
                  SizedBox(height: 8,),

                  //Forget screen navigate text
                  Align(
                    alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotScreen(),));
                        },
                        child: Text("Forgot password",style: TextStyle(
                          color:AppColor().primariColor,
                          fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),),
                      )),
                  SizedBox(height: 13,),

                  //error text
                  if (authProvider.errorMessage != null)
                    Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  SizedBox(height: 10,),

                  //Login Button
                  GestureDetector(
                    onTap:authProvider.isLoading? null:_handleLogin,
                    child: Container(
                      height: 43,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: authProvider.isLoading?
                      Center(
                        child: Text("Please Wait..",style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),),
                      ):Center(
                        child: Text("Login",style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  //Text
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text("don`t have an account?",style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 18
                      ),)),
                  SizedBox(height: 8,),

                  //Register screen Navigate Text
                  Align(
                    alignment: Alignment.centerRight,
                    child:GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RegistrationScreen(),));
                      },
                      child: Text("Register",style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                  ),
                    
                    
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

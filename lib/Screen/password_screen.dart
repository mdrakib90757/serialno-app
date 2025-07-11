import 'package:flutter/material.dart';
import 'package:serial_managementapp_project/Widgets/My_Appbar.dart';
import 'package:serial_managementapp_project/Widgets/custom_labeltext.dart';
import 'package:serial_managementapp_project/Widgets/custom_textfield.dart';

import '../utils/color.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController password_controller = TextEditingController();
  final TextEditingController  Newpassword_controller = TextEditingController();
  final TextEditingController  Confirmpassword_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: MyAppbar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      icon: Icon(Icons.arrow_back,color: AppColor().primariColor,)),
                  Text("Account Password",style: TextStyle(
                      color: AppColor().primariColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
              SizedBox(height: 20,),
              CustomLabeltext("Password"),
              SizedBox(height: 12,),
              CustomTextField(
                controller: password_controller,
                hintText: "Current Password",
                isPassword: true,
                prefixIcon: Icons.lock_outline
              ),
              SizedBox(height: 20,),
              CustomLabeltext("New Password"),
              SizedBox(height: 12,),
              CustomTextField(
                controller: Newpassword_controller,
                  hintText: "New Password",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline
              ),
              SizedBox(height: 20,),
              CustomLabeltext("Confirm Password"),
              SizedBox(height: 12,),
              CustomTextField(
                controller: Confirmpassword_controller,
                  hintText: "Confirm Password",
                  isPassword: true,
                  prefixIcon: Icons.lock_outline
              ),

              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  if(_formkey.currentState!.validate()){

                  }
                },
                child: Container(
                  height: 43,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColor().primariColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Change Password",style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

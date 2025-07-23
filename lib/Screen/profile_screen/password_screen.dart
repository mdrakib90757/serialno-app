

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/my_Appbar.dart';
import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../providers/password_upadate_provider.dart';
import '../../utils/color.dart';

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

  bool obscureIndex1=true;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    password_controller.clear();
    Newpassword_controller.clear();
    Confirmpassword_controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    final changePassword=Provider.of<PasswordUpdateProvider>(context);

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


              CustomLabeltext("Current Password"),
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
              TextFormField(
                onChanged:(value) {
                  setState(() => _autovalidateMode = AutovalidateMode.always);
                  _formkey.currentState?.validate();
                },
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Required";
                  }else{
                    if(value!=Newpassword_controller.text){
                      return "Passwords do not match";
                    }
                  }
                  return null;
                },

                controller: Confirmpassword_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.shade400
                      )
                  ),
                  focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.shade400
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.shade400
                      )
                  ),
                  prefixIcon: Icon(Icons.lock_outline,color: Colors.grey.shade400,),
                  hintText: "Confirm password",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 15
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureIndex1=!obscureIndex1;
                        _formkey.currentState?.validate();
                      });
                    }, icon:Icon(obscureIndex1?Icons.visibility_off_outlined:Icons.visibility_off_outlined,
                    color: Colors.grey.shade500,),
                  ),
                ),
                obscureText: obscureIndex1,
                obscuringCharacter: "*",
              ),

              SizedBox(height: 20,),
              GestureDetector(
                onTap: ()async {

                  if(_formkey.currentState!.validate()){
                  }
                  final sucess= await changePassword.fetchUpdatePassword(
                    currentPassword: password_controller.text,
                    newPassword: Newpassword_controller.text,
                  );
                  if(sucess){
                    await CustomFlushbar.showSuccess(
                        context: context,
                        title: "Success",
                        message: "Password update Successful"
                    );
                    Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: CustomSnackBarWidget(
                            title: "Error",
                            message:"Password Update Failed",
                            iconColor: Colors.red.shade400,
                            icon: Icons.dangerous_outlined,),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                        )

                    );
                  }

                },
                child: Container(
                  height: 43,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColor().primariColor,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: changePassword.isLoading?
                  Center(
                    child: Text("Please Wait..",style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),),
                  ):Center(
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

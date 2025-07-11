


import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Widgets/MyRadio%20Button.dart';
import 'package:serial_managementapp_project/Widgets/custom_organizationn.dart';
import 'package:serial_managementapp_project/Widgets/custom_textfield.dart';
import 'package:serial_managementapp_project/model/user_model.dart';
import 'package:serial_managementapp_project/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/custom_labeltext.dart';


import '../../model/user_model.dart';
import '../../providers/auth_providers.dart';
import '../../utils/color.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

enum UserType {
  ServiceCenter , ServiceTaker
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  List<Businesstype> _businessTypes = [];
  Businesstype? _selectedBusinessType;
  bool _isLoadingBusinessTypes  = false;
  String? _businessTypeError;
   UserType? _SelectUserType=UserType.ServiceCenter;
   bool obscureIndex= true;
   bool obscureIndex1=true;
  final List<String>genderList=["Male","Female","Other"];
  String?_selectGenter;
  final TextEditingController _textEditingController = TextEditingController();
   List<String> _history = [];



   TextEditingController name = TextEditingController();
   TextEditingController AddressLine1 = TextEditingController();
   TextEditingController AddressLine2 = TextEditingController();
   TextEditingController ContactName = TextEditingController();
   TextEditingController Email = TextEditingController();
   TextEditingController phone = TextEditingController();
   TextEditingController Organization = TextEditingController();
   TextEditingController BusinessType = TextEditingController();
   TextEditingController LoginName = TextEditingController();
   TextEditingController Password = TextEditingController();
   TextEditingController ConfirmPassword = TextEditingController();
  TextEditingController gender = TextEditingController();


  @override
  void dispose() {
    name.dispose();
    AddressLine1.dispose();
    AddressLine2.dispose();
    ContactName.dispose();
    Email.dispose();
    phone.dispose();
    Organization.dispose();
    LoginName.dispose();
    Password.dispose();
    ConfirmPassword.dispose();
    super.dispose();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBusinessTypes();
    _loadHistory();
  }

// BusinessType LoadIng
  Future<void>_loadBusinessTypes()async{
setState(() {
  _isLoadingBusinessTypes=true;
  _businessTypeError=null;
});
try{
  final types = await BusinessTypeService().getBusinessTypes();
  setState(() {
    _businessTypes = types;
   _selectedBusinessType=null;
    print("Loaded Business Types: ${types.length}");
  });
}catch(e){
  setState(() {
    _businessTypeError = e.toString();
    _businessTypeError = "Failed to load business types";
    debugPrint('Error loading business types: $e');
  });
}finally{
  setState(() {
    _isLoadingBusinessTypes=false;
  });
}
  }


  //load  organization data
  Future<void> _loadHistory()async{
    final prefs=await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList("history",)??[];
    });
  }


  //save organization data
  Future<void>_saveHistory()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setStringList("history", _history);
  }


  @override
  Widget build(BuildContext context) {
    final authProvider= Provider.of<AuthProvider>(context);
    return Form(
      key: _formkey,
      autovalidateMode:_autovalidateMode ,
      child: Scaffold(
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
               Row(
                 children: [
                   IconButton(onPressed: () {
                     Navigator.pop(context);
                   },
                       icon: Icon(Icons.arrow_back,color: AppColor().primariColor,)),
                   Text("Registration",style: TextStyle(
                       color: AppColor().primariColor,
                       fontSize: 25,
                       fontWeight: FontWeight.bold
                   ),)
                 ],
               ),
                SizedBox(height: 20,),
               //Custom Radio Button
                
                MyRadioButton(
                  initialSelection: _SelectUserType,
                  onChanged: (UserType? newValue) {
                  setState(() {
                    _SelectUserType =newValue;
                  });
                },),

                //Service Center
                Visibility(
                    visible: _SelectUserType==UserType.ServiceCenter,
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomLabeltext("Name"),
                          SizedBox(height: 10,),
                         CustomTextField(
                           hintText:"Name",
                             isPassword: false,
                             controller: name,

                         ),

                          SizedBox(height: 20,),
                          CustomLabeltext("Address Line 1"),
                          SizedBox(height: 12,),
                          CustomTextField(
                              hintText: "Address Line 1",
                              isPassword: false,
                              controller: AddressLine1
                          ),

                          SizedBox(height: 20,),
                          Text("Address Line 2"
                            ,style: TextStyle(
                              color: Colors.black,
                              fontSize: 17
                          ),),
                          SizedBox(height: 12,),
                          TextFormField(
                            controller: AddressLine2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().primariColor,width: 2
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),

                                hintText: "Address Line 2",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15
                                )
                            ),

                          ),

                          SizedBox(height: 20,),
                          CustomLabeltext("Contact Name"),
                          SizedBox(height: 12,),
                          CustomTextField(
                              hintText: "Contact Name",
                              isPassword: false,
                              controller: ContactName
                          ),

                          SizedBox(height: 20,),
                          Text("Email Address"
                            ,style: TextStyle(
                                color: Colors.black,
                                fontSize: 17
                            ),),
                          SizedBox(height: 12,),
                          TextFormField(
                            controller: Email,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),
                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().primariColor,width: 2
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),

                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15
                                )
                            ),

                          ),


                          SizedBox(height: 20,),
                          CustomLabeltext("Mobile Number"),
                          SizedBox(height: 12,),
                          CustomTextField(
                              hintText: "Mobile Number",
                              isPassword: false,
                              controller: phone
                          ),



                          SizedBox(height: 20,),
                          CustomLabeltext("Business Type"),
                          SizedBox(height: 12,),
                         _businessTypes.isEmpty?Center(child: CircularProgressIndicator(
                           color: AppColor().primariColor,
                         )):
                            DropdownButtonFormField<Businesstype?>(
                              decoration: InputDecoration(
                                hintText: "Business Type",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade100,
                                    fontSize: 15
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: AppColor().primariColor,
                                      width: 2
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade400),
                                ),

                              ),
                              value: _selectedBusinessType,
                              items: [ DropdownMenuItem<Businesstype?>(
                                  value: null,
                                  child: Text("Select")),
                                ..._businessTypes.map((type) =>
                                    DropdownMenuItem<Businesstype?>(
                                        value: type,
                                        child: Text(type.name)
                                    ))
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedBusinessType = newValue;
                                  // // অর্গানাইজেশন ফিল্ড শো/হাইড করার জন্য
                                  // if(newValue?.name.toLowerCase() != "medical") {
                                  //   Organization.clear();
                                  // }
                                });
                              },
                              validator: (value) {
                                if (value == null)
                                  return "Please select a business type";
                                return null;
                              },
                            ),

                            SizedBox(height: 20,),
                            if( _selectedBusinessType?.name.toLowerCase() ==
                                "medical")...[
                              Text("Organization"
                                , style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.50
                                ),),
                              SizedBox(height: 12,),
                              Autocomplete<String>(

                                optionsBuilder: (
                                    TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return _history.where((String option) {
                                    return option.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                onSelected: (String selection) {
                                  _textEditingController.text = selection;
                                  Organization.text = selection;
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController fieldTextEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(

                                    controller: fieldTextEditingController,
                                    focusNode: focusNode,
                                    cursorColor: Colors.grey.shade500,

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      isDense: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColor().primariColor,width: 2),


                                      ),
                                      hintText: "Organization",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),


                                    onChanged: (value) {
                                      _textEditingController.text = value;
                                      Organization.text = value;
                                    },
                                  );
                                },
                                optionsViewBuilder: (context, onSelected,
                                    options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4,

                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.9,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: options.length,
                                          itemBuilder: (context, index) {
                                            final option = options.elementAt(
                                                index);
                                            return ListTile(
                                              title: Text(option),
                                              onTap: () => onSelected(option),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                            ],

                          SizedBox(height: 20,),
                          CustomLabeltext("Login Name"),
                          SizedBox(height: 12,),
                          CustomTextField(
                            hintText: "Login name",
                            isPassword: false,
                            controller: LoginName,
                          ),


                          SizedBox(height: 20,),
                          CustomLabeltext("Password"),
                          SizedBox(height: 12,),
                         CustomTextField(
                             hintText: "Passwrod",
                             isPassword: true,
                           controller: Password,
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
                                if(value!=Password.text){
                                  return "Passwords do not match";
                                }
                              }
                              return null;
                            },

                            controller: ConfirmPassword,
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
                            onTap: authProvider.isLoading?null:
                            () async {
                              setState(() => _autovalidateMode = AutovalidateMode.always);

                              if(_formkey.currentState!.validate()) {

                              final result = await authProvider.register(
                                name: name.text,
                                addressLine1: AddressLine1.text,
                                addressLine2: AddressLine2.text,
                                contactName: ContactName.text,
                                email: Email.text,
                                phone: phone.text,
                                organizationName: Organization.text,
                                businessTypeId: _selectedBusinessType?.id ??
                                    _businessTypes.indexOf(_selectedBusinessType!),
                                loginName: LoginName.text,
                                password: Password.text,
                              );

                              if (_textEditingController.text.isNotEmpty &&
                                  !_history.contains(_textEditingController.text)) {
                                setState(() {
                                  _history.add(_textEditingController.text);
                                });
                                await _saveHistory();
                                //_textEditingController.clear();
                              }
                              if (result ?["success"] == true) {

                                await  Flushbar(
                                  title: "Success",
                                  mainButton: TextButton(
                                    onPressed: () {
                                      // Optional: Dismiss or any action
                                    },
                                    child: Text("OK", style: TextStyle(color: AppColor().primariColor)),
                                  ),
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  borderColor: Colors.grey,
                                  borderWidth: 1,
                                  message: "Registration Successful",
                                  messageColor: Colors.black,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: Colors.white,
                                  flushbarPosition: FlushbarPosition.TOP,
                                  isDismissible: true,
                                ).show(context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),));

                              } else {

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.dangerous_outlined,
                                                      color: Colors.red,size: 40,),
                                                    SizedBox(width: 10,),
                                                    Text("Error",style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18
                                                    ),),
                                                    IconButton(onPressed: () {
                                                      
                                                    }, icon: Icon(Icons.close,))
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                                  child: Text(result?['message'] ??
                                                      'Registration Failed',style: TextStyle(
                                                      color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      backgroundColor: Colors.white,
                                      behavior: SnackBarBehavior.floating,

                                    ));
                              }
                            }},

                            child: Container(
                              height: 43,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: AppColor().primariColor,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: authProvider.isLoading ?
                                  Center(child: Text("Please Wait..",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600
                                  ),)):
                              Center(
                                child: Text("Registration",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),),
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                ),


                //Service Taker Option
                Visibility(
                    visible: _SelectUserType==UserType.ServiceTaker,
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomLabeltext("Name"),
                          SizedBox(height: 12,),
                          CustomTextField(
                            hintText:"Name",
                            isPassword: false,
                            controller: name,

                          ),

                          SizedBox(height: 20,),
                          Text("Email Address"
                            ,style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.50
                            ),),
                          SizedBox(height: 12,),
                          TextFormField(
                            controller: Email,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),
                                focusedBorder:OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:  Colors.grey.shade400,)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400
                                    )
                                ),

                                hintText: "Email Address",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15
                                )
                            ),

                          ),


                          SizedBox(height: 20,),
                          CustomLabeltext("Mobile Number"),
                          SizedBox(height: 12,),
                          CustomTextField(
                              hintText: "Mobile Number",
                              isPassword: false,
                              controller: phone
                          ),

                          SizedBox(height: 20,),
                          CustomLabeltext("Gender"),
                          SizedBox(height: 12,),
                          DropdownButtonFormField<String>(
                            validator: (value) => value == null || value.isEmpty ? "Required" : null,
                            autovalidateMode: _autovalidateMode,
                            onChanged: (newValue) {
                              setState(() {
                                _autovalidateMode = AutovalidateMode.always;
                                _selectGenter = newValue ?? ''; // Null safety যোগ করুন
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Gender",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade50,
                                fontSize: 15
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:BorderSide(
                                    color: Colors.grey.shade400,
                                  )
                              ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade400,),
                                )
                            ),
                              value: _selectGenter,
                              items: genderList.map((String value){
                                return DropdownMenuItem(
                                  value: value ,
                                    child:Text(value));
                              }).toList(),

                          ),

                          SizedBox(height: 20,),
                          CustomLabeltext("Login Name"),
                          SizedBox(height: 12,),
                          CustomTextField(
                            hintText: "Login name",
                            isPassword: false,
                            controller: LoginName,
                          ),

                          SizedBox(height: 20,),
                          CustomLabeltext("Password"),
                          SizedBox(height: 12,),
                          CustomTextField(
                            hintText: "Passwrod",
                            isPassword: true,
                            controller: Password,
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
                                if(value!=Password.text){
                                  return "Passwords do not match";
                                }
                              }
                              return null;
                            },

                            controller: ConfirmPassword,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade400
                                  )
                              ),
                              focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  Colors.grey.shade400,),

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
                            onTap: authProvider.isLoading?null:
                            ()async{
                              setState(() =>_autovalidateMode = AutovalidateMode.always);
                              if(!_formkey.currentState!.validate()) return;
                              if(Password.text!= ConfirmPassword.text){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Passwords do not match')),
                                );
                                return;
                              }
                                final result=await authProvider.serviceTakerRegister(
                                    name: name.text.trim(),
                                    email: Email.text.trim(),
                                    phone: phone.text.trim(),
                                    loginName: LoginName.text.trim(),
                                  password: Password.text,
                                  gender: _selectGenter??"male"
                                );
                                if(result?["success"]==true){

                                  await  Flushbar(
                                    title: "Success",
                                    mainButton: TextButton(
                                      onPressed: () {
                                        // Optional: Dismiss or any action
                                      },
                                      child: Text("OK", style: TextStyle(color: AppColor().primariColor)),
                                    ),
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    borderColor: Colors.grey,
                                    borderWidth: 1,
                                    message: "Registration Successful",
                                    messageColor: Colors.black,
                                    duration: Duration(seconds: 2),
                                    margin: EdgeInsets.all(20),
                                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                    borderRadius: BorderRadius.circular(8),
                                    backgroundColor: Colors.white,
                                    flushbarPosition: FlushbarPosition.TOP,
                                    isDismissible: true,
                                  ).show(context);

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginScreen()),

                                    );

                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.dangerous_outlined,
                                                      color: Colors.red,size: 40,),
                                                    SizedBox(width: 10,),
                                                    Text("Error",style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20
                                                    ),),
                                                    Spacer(),
                                                    IconButton(onPressed: () {

                                                    }, icon: Icon(Icons.close,color: Colors.red,))
                                                  ],
                                                ),
                                                SizedBox(height: 10,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                                  child: Text(result?['message'] ??
                                                      'Registration Failed',style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400,
                                                  ),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        behavior: SnackBarBehavior.floating,
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
                              child:authProvider.isLoading?
                              Center(child: Text("Please Wait..",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                              ),)):
                              Center(child: Text("Registration",style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600
                                ),),
                              ),
                            )
                          )
                        ],
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  
}


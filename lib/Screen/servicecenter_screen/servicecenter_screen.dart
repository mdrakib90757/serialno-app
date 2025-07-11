import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:serial_managementapp_project/Widgets/custom_labeltext.dart';
import 'package:serial_managementapp_project/Widgets/custom_textfield.dart';
import 'package:serial_managementapp_project/providers/auth_providers.dart';
import 'package:serial_managementapp_project/utils/color.dart';

import '../../model/user_model.dart';
import '../../services/auth_service.dart';

class ServicecenterScreen extends StatefulWidget {
  const ServicecenterScreen({super.key});

  @override
  State<ServicecenterScreen> createState() => _ServicecenterScreenState();
}

class _ServicecenterScreenState extends State<ServicecenterScreen> {

  Businesstype? _userBusinessType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserBusinessType();
  }

  Future<void> _loadUserBusinessType() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 1. প্রথমে ইউজারের কোম্পানি টাইপ চেক করুন
      final companyType = authProvider.user_model?.company?.name;

      // 2. যদি API থেকে বিজনেস টাইপ লোড করার প্রয়োজন হয়
      final businessTypes = await BusinessTypeService().getBusinessTypes();

      // 3. ডিফল্ট হিসেবে মেডিকেল টাইপ সেট করুন
      Businesstype? determinedType;

      if (companyType != null) {
        determinedType = businessTypes.firstWhere(
              (type) => type.name.toLowerCase() == companyType.toLowerCase(),
          orElse: () => businessTypes.firstWhere(
                (type) => type.name.toLowerCase() == 'medical',
          ),
        );
      } else {
        determinedType = businessTypes.firstWhere(
              (type) => type.name.toLowerCase() == 'medical',
        );
      }

      setState(() {
        _userBusinessType = determinedType;
        _isLoading = false;
      });

      debugPrint('Determined Business Type: ${_userBusinessType?.name}');

    } catch (e) {
      debugPrint('Error determining business type: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool get _shouldShowAddButton {
    if (_userBusinessType == null) return false;
    return _userBusinessType!.name.toLowerCase() == 'medical';
  }


  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final userModel = authProvider.user_model;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }



    return Form(
      child: Scaffold(

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // create add button
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Service Center",style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),),

                    if(_shouldShowAddButton)_buildAddButton(context)

          ]),


          SizedBox(height: 10,),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade400)
                    ),
                    child: ListTile(
                      title: Text(authProvider.user_model!.user.loginName,style: TextStyle(
                          color: AppColor().primariColor,
                          fontSize: 20
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(authProvider.user_model!.user.mobileNo,style: TextStyle(
                              color: Colors.black,
                              fontSize: 17
                          ),),
                          Text(authProvider.user_model!.user.email,style: TextStyle(
                              color: Colors.black,
                              fontSize: 17
                          ),),

                        ],
                      ),

                      trailing:GestureDetector(
                        onTap: () {

                          _showDialogBoxEDIT(context);
                        },
                        child: Text("Edit",style: TextStyle(
                          color: AppColor().scoenddaryColor,
                          fontSize: 18
                        ),),
                      )
                    ),
                  );
                },),



    ]
            ),
          ),
        ),
      )
    );
  }


  /// ✅ Correct Widget return type for Add Button
  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialogBox(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
            color: AppColor().primariColor,
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 5),
            Text(
              "Add",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }











//dialog Box
 void _showDialogBox(BuildContext context){
   final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
   final TextEditingController emailController = TextEditingController();
   TextEditingController nameController = TextEditingController();
   TextEditingController hotlinenoController = TextEditingController();

   showDialog(context: context, builder:(context) {

         return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor().primariColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          child: Container(
            //height: 415,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Form(
              key:_dialogFormKey ,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add Service Center", style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close_sharp))
                      ],
                    ),
                    SizedBox(height: 13,),
                    CustomLabeltext("Name"),
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: nameController,
                      hintText: "Name",
                        isPassword: false
                    ),
                    SizedBox(height: 13,),
                    CustomLabeltext("Hotline No."),
                    SizedBox(height: 8,),
                    CustomTextField(
                      controller: hotlinenoController,
                        hintText: "Hotline No",
                        isPassword: false
                    ),
                    SizedBox(height: 13,),
                    Text("Email",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                    ),),
                    SizedBox(height: 8,),
                    TextFormField(
                      controller: emailController,
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
                    SizedBox(height: 13,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().primariColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: () {
                              if(_dialogFormKey.currentState!.validate()){
                          
                              }
                            }, child: Text("Save", style: TextStyle(
                            color: Colors.white
                        ),)),
                        SizedBox(width: 10,),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                          
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }, child: Text("Cancel", style: TextStyle(
                            color: AppColor().primariColor
                        ),))
                      ],
                    )
                          
                          
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },);
  }



  void _showDialogBoxEDIT(BuildContext context){
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController hotlinenoController = TextEditingController();

    showDialog(context: context, builder:(context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColor().primariColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
          child: Container(
            //height: 410,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Form(
              key:_dialogFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Edit Service Center", style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),),
                        IconButton(onPressed: () {
                          Navigator.pop(context);
                        }, icon: Icon(Icons.close_sharp))
                      ],
                    ),
                    SizedBox(height: 13,),
                    CustomLabeltext("Name"),
                    SizedBox(height: 8,),
                    CustomTextField(
                      controller: nameController,
                        hintText: "Name",
                        isPassword: false
                    ),
                    SizedBox(height: 13,),
                    CustomLabeltext("Hotline No."),
                    SizedBox(height: 10,),
                    CustomTextField(
                      controller: hotlinenoController,
                        hintText: "Hotline No",
                        isPassword: false
                    ),
                    SizedBox(height: 13,),
                    Text("Email",style: TextStyle(
                      color: Colors.black,
                      fontSize: 17
                
                    ),),
                    SizedBox(height: 13,),
                    TextFormField(
                      controller: emailController,
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
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().primariColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: () {
                              if(_dialogFormKey.currentState!.validate()){
                
                              }
                
                            }, child: Text("Save", style: TextStyle(
                            color: Colors.white
                        ),)),
                        SizedBox(width: 10,),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }, child: Text("Cancel", style: TextStyle(
                            color: AppColor().primariColor
                        ),))
                      ],
                    )
                
                
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },);
  }
}

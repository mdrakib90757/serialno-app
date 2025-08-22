
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/Widgets/custom_flushbar.dart';
import 'package:serialno_app/Widgets/custom_labeltext.dart';
import 'package:serialno_app/Widgets/custom_sanckbar.dart';
import 'package:serialno_app/Widgets/custom_textfield.dart';
import 'package:serialno_app/model/serviceCenter_model.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButton_provider/edit_ButtonProvider.dart';
import 'package:serialno_app/providers/serviceCenter_provider/editButton_provider/get_EditButton_provider.dart';
import 'package:serialno_app/request_model/serviceCanter_request/editButton_request/edit_Button_request.dart';
import 'package:serialno_app/utils/color.dart';

class EditServiceCenterDialog extends StatefulWidget {
  final ServiceCenterModel serviceCenter;
  const EditServiceCenterDialog({super.key, required this.serviceCenter});

  @override
  State<EditServiceCenterDialog> createState() => _EditServiceCenterDialogState();
}

class _EditServiceCenterDialogState extends State<EditServiceCenterDialog> {
  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController hotlinenoController;
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: widget.serviceCenter.name);
    hotlinenoController = TextEditingController(text: widget.serviceCenter.hotlineNo);
    emailController = TextEditingController(text: widget.serviceCenter.email);

  }
  @override
  void dispose() {
    nameController.dispose();
    hotlinenoController.dispose();
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                      fontSize: 16
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
                  //Button Logic
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
                          onPressed: () async{

                            final editButtonProvider=Provider.of<EditButtonProvider>(context,listen: false);
                            final getEditButtonProvider=Provider.of<GetEditButtonProvider>(context,listen: false).selectedServiceCenterId;
                            final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context,listen: false);
                            final navigator = Navigator.of(context);
                            final companyId = Provider.of<Getprofileprovider>(context, listen: false).profileData?.currentCompany.id;

                            //Validator Logic
                            if(_dialogFormKey.currentState!.validate()){
                            }
                            if (companyId == null) {
                              return;
                            }
                            EditButtonRequest editRequest=EditButtonRequest(
                                id: widget.serviceCenter.id,
                                name: nameController.text,
                                hotlineNo: hotlinenoController.text,
                                email: emailController.text,
                                companyId:companyId
                            );
                            final success= await editButtonProvider.editButton(editRequest, companyId, widget.serviceCenter.id);
                            if(success){
                              navigator.pop();
                              //get Service Center
                              await CustomFlushbar.showSuccess(
                                  context: context,
                                  title: "Success",
                                  message: "Edit Service Center Update Successful"
                              );
                              if (companyId != null && companyId.isNotEmpty) {
                                await getAddButtonProvider.fetchGetAddButton(companyId);
                              }

                            }else{
                              navigator.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: CustomSnackBarWidget(
                                      title: "Error",
                                      message: editButtonProvider.errorMessage??"Failed to Edit Service Center Update",
                                      iconColor: Colors.red.shade400,
                                      icon: Icons.dangerous_outlined,),
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 3),
                                  )

                              );
                            }
                          }, child: Text("Save", style: TextStyle(
                          color: Colors.white
                      ),)),

                      SizedBox(width: 10,),

                      //cancel Button
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
  }
}

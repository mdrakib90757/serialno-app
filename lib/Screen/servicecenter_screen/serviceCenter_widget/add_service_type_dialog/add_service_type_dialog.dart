

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serialno_app/providers/profile_provider/getprofile_provider.dart';

import '../../../../Widgets/custom_flushbar.dart';
import '../../../../Widgets/custom_labeltext.dart';
import '../../../../Widgets/custom_sanckbar.dart';
import '../../../../Widgets/custom_textfield.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import '../../../../providers/serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../../../../request_model/serviceCanter_request/addButton_serviceType_request/addButtonServiceType_request.dart';
import '../../../../utils/color.dart';

class AddServiceTypeDialog extends StatefulWidget {
  const AddServiceTypeDialog({super.key,});

  @override
  State<AddServiceTypeDialog> createState() => _AddServiceTypeDialogState();
}

class _AddServiceTypeDialogState extends State<AddServiceTypeDialog> {


  final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    priceController.dispose();
    timeController.dispose();
  }
  Future<void>_saveAddServiceType()async{
    if (!_dialogFormKey.currentState!.validate()) return;
      final getProfileProvider = Provider.of<Getprofileprovider>(context,listen: false);
      final companyId = getProfileProvider.profileData?.currentCompany.id;
      final getAddButtonServiceType=Provider.of<GetAddButtonServiceType_Provider>(context,listen: false);
      final addButtonServiceType=Provider.of<AddButtonServiceTypeProvider>(context,listen: false);
      final navigator = Navigator.of(context);
      if (companyId == null) {
        // Show error
        return;
      }

      AddButtonServiceTypeRequest serviceTypeRequest= AddButtonServiceTypeRequest(
        name: nameController.text,
        price: priceController.text,
        defaultAllocatedTime: timeController.text,
        companyId:companyId,
      );

      final success= await addButtonServiceType.addButtonServiceType(serviceTypeRequest, companyId);

      if(success){
        navigator.pop();

        await CustomFlushbar.showSuccess(
            context: context,
            title: "Success",
            message: "ServiceType Added Successful"
        );

        await getAddButtonServiceType.fetchGetAddButton_ServiceType(companyId);

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomSnackBarWidget(
                title: "Error",
                message: addButtonServiceType.errorMessage?? "Failed to Added ServiceType",
                iconColor: Colors.red.shade400,
                icon: Icons.dangerous_outlined,),
              backgroundColor: Colors.transparent,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            )
        );
      }


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
          child: SingleChildScrollView(
            child: Form(
              key: _dialogFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Add Service Types", style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                      IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close_sharp))
                    ],
                  ),
                  SizedBox(height: 20,),

                  CustomLabeltext("Name"),
                  SizedBox(height: 8,),
                  CustomTextField(
                      controller: nameController,
                      hintText: "Name",
                      isPassword: false
                  ),
                  SizedBox(height: 20,),

                  Text("Service Price",
                    style: TextStyle(
                        fontSize: 15
                    ),),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: priceController,
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

                        hintText: "Price in BDT",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15
                        )
                    ),

                  ),
                  SizedBox(height: 20,),


                  Text("Default Allocated Time",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    ),),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: timeController,
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

                        hintText: "Time in minutes",
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
                          onPressed:_saveAddServiceType,

                          child: Text("Save", style: TextStyle(
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
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/model/serviceCenter_model.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_provider.dart';
import 'package:serial_no_app/services/company_service/serviceCenter_service/EditUpdateButtonService.dart';

import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/user_model.dart';
import '../../providers/auth_providers.dart';
import '../../providers/getprofile_provider.dart';
import '../../services/company_service/serviceCenter_service/addbutton_serviceCenter.dart';
import '../../utils/color.dart';

class ServicecenterScreen extends StatefulWidget {
  final User_Model? user;
  const ServicecenterScreen({super.key,  this.user});

  @override
  State<ServicecenterScreen> createState() => _ServicecenterScreenState();
}

class _ServicecenterScreenState extends State<ServicecenterScreen> {
  Businesstype? _userBusinessType;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetAddButtonProvider>(context, listen: false)
          .fetchGetAddButton();
    });

  }


  @override
  Widget build(BuildContext context) {
    final getprofile = Provider.of<Getprofileprovider>(context);
    final profile = getprofile.profileData;
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final bool shouldShowAddButton = profile?.currentCompany.businessTypeId == 1;
    final postAddButtonServiceCenter addButtonServiceCenter =
    postAddButtonServiceCenter();
    final buttonService=addButtonServiceCenter;

    // ডিবাগিং-এর জন্য প্রিন্ট
    debugPrint("--- ServiceCenterScreen Build ---");
    if (profile != null) {
      debugPrint("  -> Company Name: ${profile.currentCompany.name}");
      debugPrint("  -> Business Type ID: ${profile.currentCompany.businessTypeId}");
      debugPrint("  -> Should Show Add Button: $shouldShowAddButton");
    }



    return Form(
      child: Scaffold(
backgroundColor: Colors.white,
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
                    if (shouldShowAddButton) _buildAddButton(context)

                  ]
                ),
                      Divider(
                      ),

            
            
                      SizedBox(height: 10,),
            getAddButtonProvider.isLoading
                ? Center(child: CircularProgressIndicator(
              color: AppColor().primariColor,
              strokeWidth: 2.5,
            ))
                : getAddButtonProvider.serviceCenterList.isEmpty
                ? Center(child: Text("No Service Center Found.")):
            ListView.builder(
             physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:getAddButtonProvider.serviceCenterList.length,
              itemBuilder: (context, index) {
                final serviceCenter = getAddButtonProvider.serviceCenterList[index];
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: ListTile(
                    title: Text(serviceCenter.name??"NO Name",style: TextStyle(
                        color: AppColor().primariColor,
                        fontSize: 18
                    ),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(serviceCenter.hotlineNo??"No HotlineNo",style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),),
                        Text(serviceCenter.email??"No Email",style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),),

                      ],
                    ),

                    trailing:GestureDetector(
                      onTap: () {
                       _showDialogBoxEDIT(context, serviceCenter);
                      },
                      child: Text("Edit",style: TextStyle(
                        color: AppColor().scoenddaryColor,
                        fontSize: 15
                      ),),
                    )
                  ),
                );

            },)]
            ),
          ),
        ),
      )
    );
  }




  ///  Correct Widget return type for Add Button
  Widget _buildAddButton(BuildContext context) {
    final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        _showDialogBox(context, getAddButtonProvider);
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




//service Center add_dialog Box
 void _showDialogBox(BuildContext context, GetAddButtonProvider getAddButtonProvider) {
   final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();

   final authProvider = Provider.of<AuthProvider>(context, listen: false);
   final currentUser = authProvider.user_model?.user;
   TextEditingController emailController = TextEditingController(

   );
   TextEditingController nameController = TextEditingController(

   );
   TextEditingController hotlinenoController = TextEditingController(

   );

   showDialog(context: context, builder: (context) {
     return StatefulBuilder(
         builder: (BuildContext context, StateSetter dialogSetState) {

           final postAddButtonServiceCenter addButtonServiceCenter =
           postAddButtonServiceCenter();
           final getprofileprovider = Provider.of<Getprofileprovider>(context, listen: false);
           final companyId = getprofileprovider.profileData?.currentCompany.id;

           return Dialog(
             backgroundColor: Colors.white,
             insetPadding: EdgeInsets.all(10),
             shape: RoundedRectangleBorder(
                 side: BorderSide(color: AppColor().primariColor),
                 borderRadius: BorderRadius.circular(10)),
             child: Padding(
               padding: const EdgeInsets.symmetric(
                   horizontal: 15, vertical: 8),
               child: Container(
                 //height: 415,
                 width: double.infinity,
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10)
                 ),
                 child: Form(
                   key: _dialogFormKey,
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
                             hintText: "HotlineNo",
                             isPassword: false
                         ),
                         SizedBox(height: 13,),
                         Text("Email", style: TextStyle(
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
                               focusedBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: AppColor().primariColor,
                                       width: 2
                                   )
                               ),
                               enabledBorder: OutlineInputBorder(
                                   borderSide: BorderSide(
                                       color: Colors.grey.shade400
                                   )
                               ),
                               hintText: "Email",

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
                                         borderRadius: BorderRadius.circular(
                                             5)
                                     )
                                 ),
                                 onPressed: () async {
                                   final navigator = Navigator.of(context);
                                   final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context, listen: false);

                                   if (_dialogFormKey.currentState!
                                       .validate()) {
                                   }
                                   if (companyId == null) {
                                     ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(content: Text("Error: Company ID not found!"))
                                     );
                                     return;
                                   }
                                   final success = await addButtonServiceCenter.AddButtonService(
                                       id: "",
                                     name: nameController.text,
                                       hotlineNo: hotlinenoController.text,
                                       email: emailController.text,
                                     companyId:companyId,
                                   );

                                   if(success){

                                    navigator.pop();
                                    await CustomFlushbar.showSuccess(
                                        context: context,
                                        title: "Success",
                                        message: "Service Center Added Successful"
                                    );
                                    await getAddButtonProvider.fetchGetAddButton();
                                   }else{
                                     ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                           content: CustomSnackBarWidget(
                                             title: "Error",
                                             message: "Failed to Added Service",
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
                             ElevatedButton(
                                 style: ElevatedButton.styleFrom(

                                     backgroundColor: Colors.white,
                                     shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(
                                             5)
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
         });
   });

  }


//service center editDialogBox
  void _showDialogBoxEDIT(BuildContext context,ServiceCenterModel serviceCenter ){
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false,);
    final currentUser = authProvider.user_model?.user;

    TextEditingController nameController = TextEditingController(text: serviceCenter.name);
    TextEditingController hotlinenoController = TextEditingController(text: serviceCenter.hotlineNo);
    TextEditingController emailController = TextEditingController(text: serviceCenter.email);
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

                              //error Handel
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final getAddButtonProvider = Provider.of<GetAddButtonProvider>(context, listen: false);

                              //Validator Logic
                              if(_dialogFormKey.currentState!.validate()){
                              }

                              //put Edit Service
                              final success= await  Edit_updatebuttonservice().UpadetButtonService(
                                  id: serviceCenter.id,
                                  name: nameController.text,
                                  hotlineNo: hotlinenoController.text,
                                  email: emailController.text
                              );

                              if(success){
                                navigator.pop();
                                //get Service Center
                                await CustomFlushbar.showSuccess(
                                    context: context,
                                    title: "Success",
                                    message: "Edit Service Center Update Successful"
                                );

                                await getAddButtonProvider.fetchGetAddButton();

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: CustomSnackBarWidget(
                                        title: "Error",
                                        message: "Failed to Edit Service Center Update",
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
    },);
  }
}

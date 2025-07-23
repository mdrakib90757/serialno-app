import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/model/service_type_model.dart';
import 'package:serial_no_app/providers/serviceCenter_provider/getAddButton_serviceType_privider.dart';
import 'package:serial_no_app/services/company_service/serviceType_service/Update_serviceType.dart';
import 'package:serial_no_app/services/company_service/serviceType_service/addButton_service_type.dart';

import '../../Widgets/custom_flushbar.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_sanckbar.dart';
import '../../Widgets/custom_textfield.dart';
import '../../providers/auth_providers.dart';
import '../../providers/getprofile_provider.dart';
import '../../utils/color.dart';

class ServicetypeScreen extends StatefulWidget {
  const ServicetypeScreen({super.key});

  @override
  State<ServicetypeScreen> createState() => _ServicetypeScreenState();
}

class _ServicetypeScreenState extends State<ServicetypeScreen> {
  final GlobalKey _deleteButtonKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }


  Future<void> _loadInitialData() async {

    final profileProvider = context.read<Getprofileprovider>();
    final serviceTypeProvider = context.read<GetAddButton_serviceType_Provider>();


    if (profileProvider.profileData == null) {
      await profileProvider.fetchUserProfile();
    }


    final companyId = profileProvider.profileData?.currentCompany.id;


    if (mounted && companyId != null) {
      await serviceTypeProvider.fetchGetAddButton_ServiceType();
    } else {
      if (mounted) {
        debugPrint("❌ Error in ServicetypeScreen: Could not find Company ID.");

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);
    final serviceTypeProvider = Provider.of<GetAddButton_serviceType_Provider>(context);



    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // create add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Service Type",style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),),
                GestureDetector(
                  onTap: () {
                    _showDialogBox(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(

                      children: [
                        Icon(Icons.add,color: Colors.white,weight: 3,),
                        SizedBox(width: 5,),
                        Text("Add",style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w500
                        ),)
                      ],
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 10,),
            serviceTypeProvider.isLoading
                ? Center(child: CircularProgressIndicator(
              color: AppColor().primariColor,
              strokeWidth: 2.5,
            )):
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: serviceTypeProvider.serviceTypeList.length,
                itemBuilder: (context, index) {
                  final type=serviceTypeProvider.serviceTypeList[index];
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade300)
                      ),
                    child: ListTile(
                        title: Text(type.name??"N/A",style: TextStyle(
                            color: AppColor().primariColor,
                            fontSize: 18
                        ),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${type.price.toString()} BDT",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15

                                ),),
                                GestureDetector(
                                  onTap: () {
                                   _showDialogBoxEDIT(context,type);
                                  },
                                  child: Text("Edit",style: TextStyle(
                                    color: AppColor().scoenddaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ),),
                                )
                              ],
                            ),

                            Text("${type.defaultAllocatedTime.toString()} Minutes",style: TextStyle(
                                color: Colors.black,
                                fontSize: 15
                            ),),

                          ],
                        ),
                        trailing: Builder(
                            builder: (BuildContext context) { // Builder ব্যবহার করে সঠিক context নিশ্চিত করুন
                              return GestureDetector(
                                  onTap: () {
                                    // ডিলিট কনফার্মেশন মেনুটি দেখান
                                    _showDeleteConfirmationMenu(context);
                                  },
                                  child: Text("Delete", style: TextStyle(
                                      color: AppColor().scoenddaryColor,
                                      fontSize: 15
                                  ),));
                            }),
                  ));
                },),
            )


        ]
              )
      ),
    );
  }









  //service type add_dialog box
  void _showDialogBox(BuildContext context){
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController timeController = TextEditingController();


    final AddbuttonServiceType addbuttonServiceType = AddbuttonServiceType();

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
                            onPressed: () async {
                              final authProvider = Provider.of<AuthProvider>(context, listen: false);
                              final getprofileprovider = Provider.of<Getprofileprovider>(context, listen: false);
                              final companyId = getprofileprovider.profileData?.currentCompany.id;

                              if(_dialogFormKey.currentState!.validate()){}
                              final navigator = Navigator.of(context);
                              final getAddButton_serviceType_Provider=
                              Provider.of<GetAddButton_serviceType_Provider>(context,listen: false);

                              final success= await addbuttonServiceType.AddButtonService_type(
                                  name: nameController.text,
                                  price: priceController.text,
                                  defaultAllocatedTime: timeController.text,
                                companyId:companyId
                              );

                              if(success){
                                navigator.pop();

                                await CustomFlushbar.showSuccess(
                                    context: context,
                                    title: "Success",
                                    message: "ServiceType Added Successful"
                                );

                                final companyId = context.read<Getprofileprovider>().profileData?.currentCompany.id;
                                if (companyId != null) {
                                  await getAddButton_serviceType_Provider.fetchGetAddButton_ServiceType();
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: CustomSnackBarWidget(
                                        title: "Error",
                                        message: "Failed to Added ServiceType",
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

//service type Edit dialogBox
  void _showDialogBoxEDIT(BuildContext context , ServiceTypeModel serviceTypeModel){

    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final authProvider = Provider.of<AuthProvider>(context, listen: false,);
    final current_user= authProvider.user_model?.user;
    TextEditingController nameController = TextEditingController(
text: serviceTypeModel.name
    );
    TextEditingController priceController = TextEditingController(
text: serviceTypeModel.price?.toString()
    );
    TextEditingController timeController = TextEditingController(
      text:  serviceTypeModel.defaultAllocatedTime?.toString()
    );

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
                        Text("Edit Service Types", style: TextStyle(
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

                    Text("Service Price",style: TextStyle(
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
                              fontSize: 14
                          )
                      ),

                    ),
                    SizedBox(height: 20,),

                    Text("Default Allocated",style: TextStyle(
                        fontSize: 14
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

                          hintText: "Time in menutes",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13
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
                            onPressed: () async {
                              if(_dialogFormKey.currentState!.validate()){

                              }
                              //error Handel
                              final scaffoldMessenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);
                              final getAddButton_serviceType_Provider=
                              Provider.of<GetAddButton_serviceType_Provider>(context,listen: false);


                              final success = await UpdateServicetype().Update_Servicetype(
                                  id: serviceTypeModel.id,
                                  name: nameController.text,
                                  price:priceController.text,
                                  defaultAllocatedTime: timeController.text
                              );
                              if(success) {

                                navigator.pop();

                                await CustomFlushbar.showSuccess(
                                    context: context,
                                    title: "Success",
                                    message: "Edit ServiceType  Update Successful"
                                );
                                final companyId = context.read<Getprofileprovider>().profileData?.currentCompany.id;
                                if (companyId != null) {
                                  await getAddButton_serviceType_Provider.fetchGetAddButton_ServiceType();
                                }
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

  void _showDeleteConfirmationMenu(BuildContext menuContext) {
    // menuContext থেকে RenderBox এর মাধ্যমে পজিশন বের করুন
    final RenderBox renderBox = menuContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu<bool>(
      context: menuContext,
      color: Colors.white, // মেনুর ব্যাকগ্রাউন্ড কালার
      elevation: 8.0, // শ্যাডো
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      position: RelativeRect.fromLTRB(
        offset.dx,            // Left
        offset.dy + size.height*-5, // Top (বাটনের ঠিক নিচে)
        offset.dx + size.width,  // Right
        offset.dy + size.height, // Bottom
      ),
      items: [
        PopupMenuItem(
          // value: false, // এটি onTap-এর কারণে প্রয়োজন নেই
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text("Confirmation", style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 8),
              Text("Are you sure to delete?",style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 15
              ),),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(menuContext).pop(false);
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("No", style: TextStyle(color: Colors.black))),
                    ),
                  ),
                  SizedBox(width: 8,),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(menuContext).pop(true);
                    },
                    child: Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColor().primariColor,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text("Yes", style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ).then((value) {

      if (value == true) {

        print("Delete confirmed!");

      } else {

        print("Delete canceled.");
      }
    });
  }
}

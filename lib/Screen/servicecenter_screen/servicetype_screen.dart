import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_textfield.dart';
import '../../providers/auth_providers.dart';
import '../../utils/color.dart';

class ServicetypeScreen extends StatefulWidget {
  const ServicetypeScreen({super.key});

  @override
  State<ServicetypeScreen> createState() => _ServicetypeScreenState();
}

class _ServicetypeScreenState extends State<ServicetypeScreen> {

  List<Map<String , dynamic>> serviceTypeList=[
    {
      "title": "সেভ করা",
      "subtitle":"50 BDT ",
      "subtitle2":"20 Minute"
    },

    {
      "title": "চুল কাটা ও সেভ করা ",
      "subtitle":"110 BDT ",
      "subtitle2":"30 Minute"
    }
  ];
  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);
    return Scaffold(
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
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
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

            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: serviceTypeList.length,
              itemBuilder: (context, index) {
                final type=serviceTypeList[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade400)
                  ),
                  child: ListTile(
                      title: Text(type["title"],style: TextStyle(
                          color: AppColor().primariColor,
                          fontSize: 20
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(type["subtitle"],style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17
                              ),),
                              GestureDetector(
                                  onTap: () {
                                    _showDialogBoxEDIT(context);
                                  },
                                  child: Text("Edit",style: TextStyle(
                                      color: AppColor().scoenddaryColor,
                                      fontSize: 18,
                                    fontWeight: FontWeight.w500
                                  ),))

                            ],
                          ),
                          Text(type["subtitle2"],style: TextStyle(
                              color: Colors.black,
                              fontSize: 17
                          ),),

                        ],
                      ),
                      trailing:GestureDetector(
                          onTap: () {

                          },
                          child: Text("Delete",style: TextStyle(
                              color: AppColor().scoenddaryColor,
                              fontSize: 18
                          ),))
                  ),
                );
              },)


          ],
        ),
      ),
    );
  }









  //dialog box
  void _showDialogBox(BuildContext context){
    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController timeController = TextEditingController();


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
                      fontSize: 17
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
                      fontSize: 17
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
    final TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController timeController = TextEditingController();

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
                      fontSize: 17
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

                    Text("Default Allocated",style: TextStyle(
                        fontSize: 17
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

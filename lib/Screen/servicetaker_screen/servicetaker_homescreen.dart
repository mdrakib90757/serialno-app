

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serial_no_app/services/company_service/serviceCenter_service/serialServiceCenter.dart';

import '../../Widgets/MyRadio Button.dart';
import '../../Widgets/custom_labeltext.dart';
import '../../Widgets/custom_textfield.dart';
import '../../model/user_model.dart';
import '../../providers/auth_providers.dart';
import '../../services/auth_service.dart';
import '../../utils/color.dart';

class ServicetakerHomescreen extends StatefulWidget {
  const ServicetakerHomescreen({super.key});

  @override
  State<ServicetakerHomescreen> createState() => _ServicetakerHomescreenState();

}
enum UserName {
  Self , Other
}
class _ServicetakerHomescreenState extends State<ServicetakerHomescreen> {

  List<Businesstype> _businessTypes = [];
  Businesstype? _selectedBusinessType;
  bool _isLoadingBusinessTypes  = false;
  String? _businessTypeError;
  DateTime date = DateTime(2022, 12, 24);
  bool _isInit = true;
  bool _controllersInitialized = false;


  // BusinessType LoadIng
  Future<void>_loadBusinessTypes()async{
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



  @override
  void initState() {
    super.initState();
    _loadBusinessTypes();

  }



  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AuthProvider>(context, listen: false).loadUserFromToken();
      _isInit = false;
    }
    super.didChangeDependencies();
  }
  TextEditingController contactNoController = TextEditingController();
  TextEditingController NameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final authProvider=Provider.of<AuthProvider>(context);

   final today = DateFormat("yyy-MM-dd").format(DateTime.now());





    return Scaffold(
      body:  Builder(
        builder: (context) {

          if (authProvider.isLoading) {
            return Center( // <-- Center উইজেট যোগ করা হয়েছে
              child: CircularProgressIndicator(
                color: AppColor().primariColor,
                strokeWidth: 2.5,
              ),
            );
          }
          if (authProvider.user_model == null) {
            return Center( // <-- এখানেও Center ব্যবহার করা হয়েছে
              child: Text("No User Data found. Please try again."),
            );
          };
          if (!_controllersInitialized) {
            contactNoController.text = authProvider.user_model!.user.mobileNo;
            NameController.text = authProvider.user_model!.user.name;
            _controllersInitialized = true; // ফ্ল্যাগ true করে দিন যাতে এটা আর না হয়
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date", style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),),
                      GestureDetector(
                        onTap: () {
                          _showDialogBox(context);
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: AppColor().primariColor,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add, color: Colors.white, weight: 5,),
                                SizedBox(width: 7),
                                Text("Book Serial", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          );

        }));
  }
































  void _showDialogBox(BuildContext context){

    final GlobalKey<FormState> _dialogFormKey = GlobalKey<FormState>();
    TextEditingController DateController = TextEditingController();


    AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

    UserName? _SelectUserName = UserName.Self;
    showDialog(context: context, builder:(context) {


    return  StatefulBuilder(
        builder: (BuildContext context, StateSetter dialogSetState) {
          final authProvider=Provider.of<AuthProvider>(context);

          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor().primariColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                            Text("Make appointment", style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                            IconButton(onPressed: () {
                              Navigator.pop(context);
                            }, icon: Icon(Icons.close_sharp))
                          ],
                        ),


                        SizedBox(height: 10,),
                        CustomLabeltext("business type"),
                        SizedBox(height: 10,),
                        DropdownSearch<Businesstype>(
                          popupProps: PopupProps.menu(
                            menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            constraints: BoxConstraints(
                                maxHeight: 170
                            ),

                          ),

                          itemAsString: (Businesstype type) => type.name,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Select",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              suffixIcon: _isLoadingBusinessTypes ?
                              Container(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColor().primariColor,
                                  ),
                                ),
                              ) : null,
                              enabled: !_isLoadingBusinessTypes,
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

                          ),


                          selectedItem: _selectedBusinessType,

                          items: _businessTypes,

                          onChanged: (newValue) {
                            setState(() {
                              _selectedBusinessType = newValue;
                              print('✅ Selected ID: ${_selectedBusinessType?.id}');
                            });

                            dialogSetState(() {
                              _selectedBusinessType = newValue;
                            });
                          },
                          autoValidateMode: _autovalidateMode,
                          validator: (value) {
                            if (value == null)
                              return "Please select a business type";
                            return null;
                          },
                        ),
                        SizedBox(height: 10,),


                        if (_selectedBusinessType != null && _selectedBusinessType!.id == 1)...[
                        CustomLabeltext("Organization"),
                        SizedBox(height: 8,),
                        DropdownSearch<String>(
                          autoValidateMode: _autovalidateMode,
                          validator: (value) {
                            if (value == null)
                              return "Requird";
                            return null;
                          },

                          popupProps: PopupProps.menu(
                            menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            constraints: BoxConstraints(
                                maxHeight: 150
                            ),

                            emptyBuilder: (context, searchEntry) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 60,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 12),

                                      Text(
                                        'No data',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Organization",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400
                              ),
                              suffixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                          ),


                          items: [],

                          onChanged: (Newvalue) {

                            print(Newvalue);
                          },
                        ),
                        SizedBox(height: 10,),
                      ],


                        CustomLabeltext("Service Center"),
                        SizedBox(height: 8,),
                        DropdownSearch<String>(
                          autoValidateMode: _autovalidateMode,
                          validator: (value) {
                            if (value == null)
                              return "Required";
                            return null;
                          },
                          popupProps: PopupProps.menu(
                            menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            constraints: BoxConstraints(
                                maxHeight: 150
                            ),
                            emptyBuilder: (context, searchEntry) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 60,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 12),

                                      Text(
                                        'No data',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Service Center",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400
                              ),
                              suffixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                          ),


                          items: [],
                          //items: ['Google', 'Meta', 'Amazon', 'Netflix'],

                          onChanged: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(height: 10,),

                        CustomLabeltext("Service Type"),
                        SizedBox(height: 8,),
                        DropdownSearch<String>(
                          autoValidateMode: _autovalidateMode,
                          validator: (value) {
                            if (value == null)
                              return "Required";
                            return null;
                          },
                          popupProps: PopupProps.menu(
                            menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            constraints: BoxConstraints(
                                maxHeight: 150
                            ),

                            emptyBuilder: (context, searchEntry) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 60,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(height: 12),

                                      Text(
                                        'No data',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Service Type",
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400
                              ),
                              suffixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
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
                          ),


                          items: [],
                          //items: ['Google', 'Meta', 'Amazon', 'Netflix'],

                          onChanged: (value) {
                            print(value);
                          },
                        ),
                        SizedBox(height: 10,),


                         CustomLabeltext("Date"),
                         SizedBox(height: 8,),
                         CustomTextField(
                           controller: DateController,
                           hintText: "Select Date",
                           textStyle: TextStyle(
                               color: Colors.grey.shade400
                           ),
                           isPassword: false,
                           suffixIcon: IconButton(onPressed: () async
                           {
                             DateTime? newDate = await showDatePicker(
                                 builder: (context, child) {
                                   return Theme(data: Theme.of(context).copyWith(
                                     colorScheme: ColorScheme.light(
                                       primary: AppColor().primariColor,
                                       // Header color
                                       onPrimary: Colors.white,
                                       // Header text color
                                       onSurface: Colors
                                           .black, // Body text color
                                     ),
                                     dialogTheme: DialogThemeData(
                                         shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(
                                               16.0),
                                         )),
                                     textButtonTheme: TextButtonThemeData(
                                       style: TextButton.styleFrom(
                                         foregroundColor: AppColor()
                                             .primariColor, // Button text color
                                       ),
                                     ),
                                   ), child: child!);
                                 },
                                 context: context,
                                 initialDate: date,
                                 firstDate: DateTime(1900),
                                 lastDate: DateTime(2100)
                             );
                             if (newDate == null) return;
                             setState(() {
                               date = newDate;
                               DateController.text =
                               "${date.year}-${date.month.toString().padLeft(
                                   2, '0')}-${date.day.toString().padLeft(
                                   2, '0')}";
                             });
                           },
                               icon: Icon(Icons.date_range_outlined,
                                 color: Colors.grey.shade400,)),
                         ),
                         SizedBox(height: 10,),
                         Text("For",style: TextStyle(
                           color: Colors.black,
                           fontSize: 18,
                           fontWeight: FontWeight.w600
                         ),),
                         CustomRadioGroup<UserName>(
                           groupValue: _SelectUserName,
                           items: [UserName.Self,UserName.Other],
                           onChanged: (UserName? newValue) {
                             dialogSetState((){
                               _SelectUserName = newValue;
                             });
                           },
                           itemTitleBuilder: (UserName value) {
                             switch (value){
                               case UserName.Self:
                               return "Self";
                               case UserName.Other:
                                 return "Other";
                             }
                           },
                                                ),

                       Visibility(
                           visible: _SelectUserName == UserName.Self,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CustomLabeltext("Contact No",),
                               SizedBox(height: 10,),
                               CustomTextField(
                                 enabled: false,
                                 filled: true,
                                 isPassword: false,
                                 controller: contactNoController,

                               ),
                               SizedBox(height: 15,),
                               CustomLabeltext("Name"),
                               SizedBox(height: 10,),
                               CustomTextField(
                                 enabled: false,
                                 filled: true,
                                 isPassword: false,
                                 controller: NameController,

                               )
                             ],
                           )
                       ),
                       SizedBox(width: 10,),

                       Visibility(
                           visible: _SelectUserName == UserName.Other,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CustomLabeltext("Contact No"),
                               SizedBox(height: 10,),
                               CustomTextField(
                                 isPassword: false,
                                 controller: contactNoController,

                               ),
                               SizedBox(height: 15,),
                               CustomLabeltext("Name"),
                               SizedBox(height: 10,),
                               CustomTextField(

                                 isPassword: false,
                                 controller: NameController,

                               )
                             ],
                           )
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
                                  if (_dialogFormKey.currentState!.validate()) {

                                  }
                                }, child: Text("Request for serial", style: TextStyle(
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
        );
    },);
  }
}

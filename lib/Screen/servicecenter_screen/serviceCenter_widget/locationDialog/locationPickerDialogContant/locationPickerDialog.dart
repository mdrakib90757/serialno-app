import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:serialno_app/Screen/servicecenter_screen/serviceCenter_widget/locationDialog/locationDialog.dart';

import '../../../../../utils/color.dart';

class LocationPickerDialog extends StatefulWidget {
  const LocationPickerDialog({super.key});
  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  LatLng? _selectedLocationFromContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().primariColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chose Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final selectedLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text(
                                    "Choose Location",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColor().primariColor,
                                  leading: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: LocationPickerDialogContent(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColor().primariColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              "Select",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_selectedLocationFromContent !=
                                                  null) {
                                                Navigator.pop(
                                                  context,
                                                  _selectedLocationFromContent,
                                                );
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: AppColor().primariColor,
                                              ),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (selectedLocation != null) {
                            Navigator.pop(context, selectedLocation);
                          }
                        },
                        child: Icon(Icons.fullscreen, size: 30),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  menuProps: MenuProps(
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(maxHeight: 170),
                ),

                //itemAsString: (DivisionModel type) => type.name,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    // hintText: "Division",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    // suffixIcon: divisionProvider.isLoading
                    //     ? Container(
                    //   padding: EdgeInsets.all(12),
                    //   child: SizedBox(
                    //     height: 20,
                    //     width: 20,
                    //     child: CircularProgressIndicator(
                    //       strokeWidth: 2.5,
                    //       color: AppColor().primariColor,
                    //     ),
                    //   ),
                    // )
                    //     : null,

                    //  enabled: !divisionProvider.isLoading,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: AppColor().primariColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),

                // selectedItem: _selectDivision,
                //items: divisionProvider.divisions,
                // onChanged: (newValue) {
                //   setState(() {
                //     _selectDivision = newValue;
                //   });
                // },
                validator: (value) {
                  if (value == null) return "Please select a division";
                  return null;
                },
              ),
              SizedBox(height: 8),
              SizedBox(height: 500, child: LocationPickerDialogContent()),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor().primariColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Select",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_selectedLocationFromContent != null) {
                        Navigator.pop(context, _selectedLocationFromContent);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AppColor().primariColor),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

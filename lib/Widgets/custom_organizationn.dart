//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class CustomOrganizationn extends StatefulWidget {
//   final TextEditingController? controller;
//   const CustomOrganizationn({super.key, this.controller});
//
//   @override
//   State<CustomOrganizationn> createState() => _CustomOrganizationnState();
// }
//
// class _CustomOrganizationnState extends State<CustomOrganizationn> {
//   late  TextEditingController _orgController = TextEditingController();
//   List<String> _previousOrganizations = [];
//
//   @override
//   void initState() {
//     _orgController = widget.controller??TextEditingController();
//     super.initState();
//     _loadPreviousOrganizations();
//   }
//
//   // পূর্বের সংস্থাগুলো লোড করুন
//   Future<void> _loadPreviousOrganizations() async {
//     final prefs = await SharedPreferences.getInstance();
//     final orgs=prefs.getStringList('organizations')??[];
//     setState(() {
//       _previousOrganizations = orgs;
//     });
//     print('Current organizations: $_previousOrganizations');
//   }
//
//   // নতুন সংস্থা সেভ করুন
//   Future<void> _saveOrganization(String orgName) async {
//     if(orgName.trim().isEmpty)return;
//     final prefs = await SharedPreferences.getInstance();
//     final newOrgs=[..._previousOrganizations];
//     if (!newOrgs.contains(orgName)) {
//       newOrgs.add(orgName);
//       await prefs.setStringList('organizations', _previousOrganizations);
//       setState(() {
//         _previousOrganizations=newOrgs;
//       });
//       print('Current organizations: $_previousOrganizations');
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TypeAheadField<String>(
//       textFieldConfiguration: TextFieldConfiguration(
//         controller: _orgController,
//         decoration: InputDecoration(
//           hintText: 'Organization',
//           border: OutlineInputBorder(),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//                 color: Colors.grey.shade400),
//
//
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.shade400),
//           ),
//         ),
//         onSubmitted:_saveOrganization,
//         onChanged: (value) {
//           if(value.isEmpty){
//             setState(() {
//
//             });
//           }
//         },
//       ),
//
//       suggestionsCallback: (pattern) {
//         return _previousOrganizations.where((org) =>
//             org.toLowerCase().contains(pattern.toLowerCase())
//         );
//       },
//       itemBuilder: (context, suggestion) {
//         return ListTile(
//           title: Text(suggestion),
//         );
//       },
//       onSuggestionSelected: (suggestion) {
//         _orgController.text = suggestion;
//       },
//
//       noItemsFoundBuilder: (context) => Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text('No matching organization found'),
//       ), onSelected: (String value) {  },
//     );
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     if (widget.controller == null) {
//       _orgController.dispose();
//     }
//   }
// }

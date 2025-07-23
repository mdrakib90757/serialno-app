

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ApiConfig{

  static const String baseUrl="https://serialno-api.somee.com/api/";

  static const String getprofile_endpoint="${baseUrl}me/v2/profile";

  static const String changePassword_endpoint="${baseUrl}me/password";


  static const String businessTypes_endpoint="${baseUrl}business-types";

  static const String serialno_services_data_endpoint="${baseUrl}serial-no/my-booked-services";

static const String addButton_serviceCenter_endpoint="${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-centers";

static const String get_addButton_serviceCenter_endpoint="${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-centers";


//id pase hobe
static const String  put_Edit_update_serviceCenter_endpoint_base_endpoint ="${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-centers";


static const String addButton_serviceType_endtpoint="${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-types";

static const String getAddButton_service_Type_endpoint ="${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-types";

static const String put_update_serviceType = "${baseUrl}serial-no/companies/c4df7170-dd60-4d50-8468-b7b113463b78/service-types";


static const String post_serialServiceCenter_book ="${baseUrl}serial-no/service-centers/dd53f6d8-d94c-4325-8651-012a96c6b740/services/book";


  static const String get_serialServiceCenter_book ="${baseUrl}serial-no/service-centers/dd53f6d8-d94c-4325-8651-012a96c6b740/services";




}

class Api {
  static const String baseUrl = 'https://serialno-api.somee.com';
}
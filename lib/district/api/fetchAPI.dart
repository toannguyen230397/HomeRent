import 'package:flutter/services.dart';
import 'dart:convert';

class FetchAPI {
  Future<List<Map<String, dynamic>>> getProvinceData() async {
    final response = await rootBundle.loadString('assets/data/provinceData.json');
    final List<dynamic> responseData = json.decode(response);
    return List<Map<String, dynamic>>.from(responseData);
  }

  Future<List<Map<String, dynamic>>> getDistrictData() async {
    final response = await rootBundle.loadString('assets/data/districtData.json');
    final List<dynamic> responseData = json.decode(response);
    return List<Map<String, dynamic>>.from(responseData);
  }
}
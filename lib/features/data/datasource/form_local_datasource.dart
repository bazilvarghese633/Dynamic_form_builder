import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/form_model.dart';

class FormLocalDatasource {
  Future<List<FormModel>> getForms() async {
    final jsonString = await rootBundle.loadString('assets/sample.json');

    final data = json.decode(jsonString);

    return (data['sample_json'] as List)
        .map((e) => FormModel.fromJson(e))
        .toList();
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taxonomy_method/model/rasfi_input.dart';
import 'package:taxonomy_method/model/model_results.dart';

class ApiProvider {
  final String _baseUrl =
      "https://dohlf3t1mj.execute-api.us-east-2.amazonaws.com/prod";

  final Dio _dio = Dio(
      // BaseOptions(headers: {"Access-Control-Allow-Origin": "*"})
      );

  Future<ModelResults> getRanking(RasfiInput input) async {
    String _endpoint = "${_baseUrl}/";
    try {
      Response response = await _dio.post(_endpoint, data: jsonEncode(input));
      print("success");
      print(response);
      return ModelResults.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ModelResults.withError("$error");
    }
  }
}

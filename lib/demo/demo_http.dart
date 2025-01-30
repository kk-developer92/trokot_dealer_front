import 'dart:convert';

import 'package:http/http.dart' as http;

main() async {

  final uri = Uri.parse('http://localhost:3000/product/get-list');

  Map<String, String> headers = <String, String>{
    'Content-Type': "application/json",
    'Authorization': '-Q7q8DwK38j0pCHJHdkz6uLP9sZbrFCOxUzT4lpM',
  };

  final params = <String, dynamic>{
    'skip': 0,
    'limit': 10,
  };

  final paramsNew = <String, dynamic>{
    'skip': 'foo',
    'limit': 'bar',
  };


  final paramsString = jsonEncode(params);

  print(paramsString);


  final response = await http.post(uri, headers: headers, body: paramsString).timeout(const Duration(milliseconds: 2000));
  print(response.body);




}


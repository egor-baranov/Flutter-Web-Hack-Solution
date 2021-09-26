import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:pedantic/pedantic.dart';

class RequestWorker {
  static String base = "civiltechgroup.ru:8880";

  static Future<void> addEmployeeData(
      ) async {
    var requestBody = JsonEncoder().convert({});

    print(requestBody);

    final response = await http.post(Uri.http(base, '/api/employees'),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          "X-Requested-With": "XMLHttpRequest",
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept',
          "Access-Control-Allow-Methods": "*"
        },
        body: requestBody);
    print(response.body);
  }

  static Future<List<Employee>> fetchFiltered(
    List<String> specialityList,
    Gender gender,
    RangeValues childrenCountRange,
    MaritalStatus maritalStatus,
    RangeValues rangeValuesRange,
    List<String> cities,
    List<String> educations,
    DateTime startDate,
    DateTime endDate,
  ) async {
    var requestBody = JsonEncoder().convert({
      "city": cities,
      "education": educations
          .map((e) => e == "Высшее"
              ? "higher"
              : e == "Среднее"
                  ? "school"
                  : "college")
          .toList(),
      "childrenCount": {
        "start": childrenCountRange.start,
        "end": childrenCountRange.end
      },
      "gender": gender == Gender.any
          ? null
          : gender == Gender.male
              ? "male"
              : "female",
      "is_married": maritalStatus == MaritalStatus.any
          ? null
          : maritalStatus == MaritalStatus.married,
      "salary": {
        "start": rangeValuesRange.start,
        "end": rangeValuesRange.end,
      },
      "startDate": {
        "start": startDate.toString().split(" ")[0],
        "end": "2100-01-01"
      },
      "endDate": null
    });

    print(requestBody);

    final response = await http.post(Uri.http(base, '/api/employees/filter'),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          "X-Requested-With": "XMLHttpRequest",
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept',
          "Access-Control-Allow-Methods": "*"
        },
        body: requestBody);
    print(response.body);

    Iterable l = json.decode(utf8.decode(response.bodyBytes));
    return List<Employee>.from(l.map((model) =>
        Employee.fromJson(model['employee'])
            .setPrediction(model['prediction'])));
  }
}

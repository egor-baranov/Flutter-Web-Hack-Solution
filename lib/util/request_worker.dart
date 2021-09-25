import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:leaders_of_digital_hack/model/employee.dart';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';
import 'package:pedantic/pedantic.dart';

class RequestWorker {
  static String base = "civiltechgroup.ru:8880";
  static var _api =
      IOWebSocketChannel.connect('http://civiltechgroup.ru:8880/api/');
  static var client = json_rpc.Client(_api.cast());

  static Future fetchFiltered() async {
    final response = await http.post(
      Uri.http(base, 'employees/filter/'),
      headers: <String, String>{
        "Access-Control-Allow-Origin": "*",
        "X-Requested-With": "XMLHttpRequest",
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
        "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS"
      },
    );
  }
}

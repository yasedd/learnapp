import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import '../models/app_config.dart';
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
    print(_base_url);
  }

  Future<Response?> get(String _path) async {
    String _url = "$_base_url$_path";
    Response? _responce;
    try {
      // print(_url);
      // dio.get("", options: Options(headers: {"API_KEY": ""}));
      // dio.get("", queryParameters: {"id": 1});
      // Response? _responce =
      //     await dio.get(_url, queryParameters: {"id": "bitcoin"});
      _responce = await dio.get(_url);
      print(_responce);
    } catch (e) {
      print('HTTPService: Unable to preform get request.');
      print(e);
    }
    return _responce;
  }
}

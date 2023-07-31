import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:learnapp/models/app_config.dart';
import 'package:learnapp/services/http_service.dart';
import 'pages/firstpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadConfig();
  registerHTTPService();
  // await GetIt.instance.get<HTTPService>().get("/coins/bitcoin");
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");
  // print(_configContent);
  Map _configData = jsonDecode(_configContent);
  // print(_configData);
  GetIt.instance.registerSingleton<AppConfig>(
      AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"]));
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter learning',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.purple[900],
          primarySwatch: Colors.blue),
      home: FirstPage(),
    );
  }
}

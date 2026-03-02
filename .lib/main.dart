import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      checkForUpdate();
    });
  }

  Future<void> checkForUpdate() async {

    final response = await http.get(
      Uri.parse("https://raw.githubusercontent.com/USERNAME/REPO/main/update/version.json"),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);
      int latestVersion = data["versionCode"];
      String apkUrl = data["apkUrl"];

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentVersion = int.parse(packageInfo.buildNumber);

      if (latestVersion > currentVersion) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("يوجد تحديث"),
            content: Text("يوجد إصدار جديد من التطبيق"),
            actions: [
              TextButton(
                onPressed: () async {
                  await launchUrl(Uri.parse(apkUrl));
                },
                child: Text("تحديث"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تطبيقي الأول"),
      ),
      body: Center(
        child: Text(
          "الإصدار 1",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstarlab_test/root_binding.dart';
import 'package:monstarlab_test/ui/gallery_screen.dart';

enum Flavor {
  development,
  production,
}

class MainCommon extends StatelessWidget {
  final String flavor;
  const MainCommon({Key? key, required this.flavor}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoListScreen(),
      initialBinding: RootBinding(),
    );
  }
}

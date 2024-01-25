import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:region_of_interest/region_of_interest.dart';

//import 'package:path_provider/path_provider.dart';
//import 'package:simple_permissions/simple_permissions.dart';

const directoryName = 'Signature';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  runApp(MaterialApp(
    home: TestApp(cameras: cameras,),
    debugShowCheckedModeBanner: false,
  ));
}


class TestApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const TestApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return  CameraScreen(cameras: cameras);
  }
}
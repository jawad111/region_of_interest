import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:region_of_interest/region_of_interest.dart';


Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Pass a specific camera from the list of available cameras.
  runApp(MaterialApp(
    home: TestApp(camera: cameras[0],),
    debugShowCheckedModeBanner: false,
  ));
}




class TestApp extends StatelessWidget {
  final CameraDescription camera;
  const TestApp({super.key, required this.camera});


  

  @override
  Widget build(BuildContext context) {
    callBackFunction(Uint8List orignalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfIntrest) {
    if (orignalImage != null) {
      // If the picture was taken, display it on a new screen.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          // Pass the automatically generated path to
          // the BytesImageView widget.
          imageProvider: MemoryImage(imageWithBoundingBox),
        ),
      ));
    }
  }
    return  CaptureRegionWidget(camera: camera, callback: callBackFunction);
  }
}
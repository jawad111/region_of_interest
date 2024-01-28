import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:region_of_interest/region_of_interest.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Pass a specific camera from the list of available cameras.
  runApp(MaterialApp(
    home: MyApp(camera: cameras[0]),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Region Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Use Case 1: Send images and bounding box to API
                _sendToApi(context);
              },
              child: Text('Send to API'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Use Case 2: Generate dataset using original image and bounding box
                _generateDataset(context);
              },
              child: Text('Generate Dataset'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Use Case 3: Display captured image using existing class
                _displayCapturedImage(context);
              },
              child: Text('Display Captured Image'),
            ),
          ],
        ),
      ),
    );
  }

  // Use Case 1: Send images and bounding box to API
  void _sendToApi(BuildContext context) async {
    OnImageCaptured callback = (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
      // Handle the captured images and bounding box as needed
      // Send the original image, image with bounding box, and bounding box to the API
      // Replace the following code with your API call logic
      print('Sending to API:');
      print('Original Image Size: ${originalImage.lengthInBytes} bytes');
      print('Bounding Box: $regionOfInterest');
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptureRegionWidget(camera: camera, callback: callback),
      ),
    );
  }

  // Use Case 2: Generate dataset using original image and bounding box
  void _generateDataset(BuildContext context) async {
    OnImageCaptured callback = (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
      // Handle the captured images and bounding box as needed
      // Generate a dataset using the original image and bounding box
      // Replace the following code with your dataset generation logic
      print('Generating Dataset:');
      print('Original Image Size: ${originalImage.lengthInBytes} bytes');
      print('Bounding Box: $regionOfInterest');
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptureRegionWidget(camera: camera, callback: callback),
      ),
    );
  }

  // Use Case 3: Display captured image using existing class
  void _displayCapturedImage(BuildContext context) async {
    OnImageCaptured callback = (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
      // Handle the captured images and bounding box as needed
      // Display the captured image using the existing class
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imageProvider: MemoryImage(originalImage)),
        ),
      );
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaptureRegionWidget(camera: camera, callback: callback),
      ),
    );
  }
}
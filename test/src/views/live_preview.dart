import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:region_of_interest/region_of_interest.dart';

// Tests Need to be refined in upcoming patches

void main() {
  testWidgets('Preview widget displays camera preview', (WidgetTester tester) async {
     //Mock Data
    final Uint8List image = Uint8List(0);
    final Uint8List image2 = Uint8List(0);
     final boundingBox = BoundingBox(
      topLeft: Offset(10.0, 20.0),
      topRight: Offset(30.0, 20.0),
      bottomLeft: Offset(10.0, 40.0),
      bottomRight: Offset(30.0, 40.0),
    );
    // Build our widget and trigger a frame.
    await tester.pumpWidget(Preview(
      cameraController: CameraController(
        CameraDescription(name: 'mock', lensDirection: CameraLensDirection.back, sensorOrientation: 90),
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      ),
      callback: (image, image2, boundingBox) {},
    ));

    // Expect camera preview to be displayed.
    expect(find.byType(CameraPreview), findsOneWidget);
  });
}
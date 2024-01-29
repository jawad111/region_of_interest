import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:region_of_interest/region_of_interest.dart';
import 'package:mockito/mockito.dart';

// Tests Need to be refined in upcoming patches

void main() {
  test('ImageProcessingManager - Process Image', () async {
    // Arrange
    final XFile mockXFile = XFile(
        "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");

    final rectanglePoints = BoundingBox(
      topLeft: const Offset(10.0, 20.0),
      topRight: const Offset(30.0, 20.0),
      bottomLeft: const Offset(10.0, 40.0),
      bottomRight: const Offset(30.0, 40.0),
    );

    final rawImageBytes = Uint8List.fromList([1, 2, 3, 4]);
    when(mockXFile.path).thenReturn('/path/to/image.jpg');
    when(ImageController.drawOnImage(mockXFile, rectanglePoints))
        .thenAnswer((_) async => rawImageBytes);

    final expectedRectanglePoints = BoundingBox(
      topLeft: const Offset(10.0, 20.0),
      topRight: const Offset(30.0, 20.0),
      bottomLeft: const Offset(10.0, 40.0),
      bottomRight: const Offset(30.0, 40.0),
    );

    const screenDisplaySize = Size(100.0, 100.0);
    final image = img.Image(width: 100, height: 100);
    final imageBytesWithRegion = Uint8List.fromList([5, 6, 7, 8]);

    when(ImageController.getImageSizeFromBytes(rawImageBytes))
        .thenAnswer((_) async => const Size(100.0, 100.0));

    bool callbackCalled = false;
    void callback(Uint8List originalImage, Uint8List imageWithBoundingBox,
        BoundingBox regionOfInterest) {
      callbackCalled = true;
      // Add assertions for the callback parameters
      expect(originalImage, equals(rawImageBytes));
      expect(imageWithBoundingBox, equals(imageBytesWithRegion));
      expect(regionOfInterest, equals(expectedRectanglePoints));
    }

    // Act
    await ImageProcessingManager.process(
        mockXFile,
        {'x': 10.0, 'y': 20.0, 'w': 20.0, 'h': 20.0},
        screenDisplaySize,
        callback);

    // Assert
    expect(callbackCalled, isTrue);
  });
}

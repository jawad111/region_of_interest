import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:region_of_interest/region_of_interest.dart';

// Tests Need to be refined in upcoming patches

void main() {
  group('TransformationController Tests', () {
    test('Transform Point', () {
      // Define a primary coordinate system (screen resolution)
      Size primaryCoordinateSystem = const Size(1920, 1080);

      // Define a secondary coordinate system (image resolution)
      Size secondaryCoordinateSystem = const Size(800, 600);

      // Define a point in the primary coordinate system
      Offset pointInPrimary = const Offset(100, 200);

      // Transform the point to the secondary coordinate system
      Offset transformedPoint = TransformationController.transformPoint(
        pointInPrimary,
        primaryCoordinateSystem,
        secondaryCoordinateSystem,
      );

      // Check if the transformed point is correct
      expect(transformedPoint, equals(const Offset(266.6666666666667, 400.0)));
    });

    test('Decrease Image Ratio', () {
      // Define the original image resolution
      Size originalResolution = const Size(800, 600);

      // Define the factor by which the resolution should be decreased
      double decreaseFactor = 2.0;

      // Calculate the decreased resolution
      Size decreasedResolution = TransformationController.decreaseImageRatio(
          originalResolution, decreaseFactor);

      // Check if the decreased resolution is correct
      expect(decreasedResolution, equals(const Size(400.0, 300.0)));
    });

    // Similar tests can be added for other functions like increaseImageRatio, calculateCenterOfRectangle, etc.

    test('Calculate Region of Interest on Screen', () {
      // Define the start and end points of the finger interaction on the screen
      Offset startPoint = const Offset(100, 200);
      Offset endPoint = const Offset(50, 50);

      // Calculate the region of interest on the screen
      List<Offset> regionOnScreen =
          TransformationController.calculateRegionOfInterestOnScreen(
              startPoint, endPoint);

      // Check if the calculated region on the screen is correct
      expect(
          regionOnScreen,
          equals([
            const Offset(100, 200),
            const Offset(150, 200),
            const Offset(100, 250),
            const Offset(150, 250)
          ]));
    });

    // Add tests for other functions as needed

    test('Transform Region of Interest on Image', () {
      // Define the start and end points of the finger interaction on the screen
      Offset startPoint = const Offset(100, 200);
      Offset endPoint = const Offset(50, 50);

      // Define the screen resolution and image resolution
      Size screenResolution = const Size(1920, 1080);
      Size imageResolution = const Size(800, 600);

      // Transform the region of interest on the screen to the image
      BoundingBox transformedRegion =
          TransformationController.transformRegionOfInterestOnImage(
        startPoint,
        endPoint,
        screenResolution,
        imageResolution,
      );

      // Check if the transformed region on the image is correct
      expect(
        transformedRegion.toJson(),
        equals({
          'topLeftX': 266.6666666666667,
          'topLeftY': 400.0,
          'topRightX': 400.0,
          'topRightY': 400.0,
          'bottomLeftX': 266.6666666666667,
          'bottomLeftY': 533.3333333333334,
          'bottomRightX': 400.0,
          'bottomRightY': 533.3333333333334,
        }),
      );
    });

    // Add tests for other functions as needed
  });
}

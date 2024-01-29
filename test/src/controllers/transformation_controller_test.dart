import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:region_of_interest/region_of_interest.dart' as pkg;

// Tests Need to be refined in upcoming patches

void main() {
  test('TransformationController - Transform Point', () {
    // Arrange
    const primaryCoordinateSystem = Size(100.0, 100.0);
    const secondaryCoordinateSystem = Size(200.0, 200.0);
    const startPoint = Offset(30.0, 40.0);

    // Act
    final transformedPoint = pkg.TransformationController.transformPoint(
        startPoint, primaryCoordinateSystem, secondaryCoordinateSystem);

    // Assert
    expect(transformedPoint, equals(const Offset(60.0, 80.0)));
  });

  test('TransformationController - Decrease Image Ratio', () {
    // Arrange
    const originalResolution = Size(200.0, 150.0);
    const factor = 2.0;

    // Act
    final decreasedResolution = pkg.TransformationController.decreaseImageRatio(
        originalResolution, factor);

    // Assert
    expect(decreasedResolution, equals(const Size(100.0, 75.0)));
  });

  test('TransformationController - Increase Image Ratio', () {
    // Arrange
    const originalResolution = Size(200.0, 150.0);
    const factor = 2.0;

    // Act
    final increasedResolution = pkg.TransformationController.increaseImageRatio(
        originalResolution, factor);

    // Assert
    expect(increasedResolution, equals(const Size(400.0, 300.0)));
  });

  test('TransformationController - Calculate Center of Rectangle', () {
    // Arrange
    const edgePoint1 = Offset(10.0, 20.0);
    const edgePoint2 = Offset(30.0, 40.0);

    // Act
    final centerPoint = pkg.TransformationController.calculateCenterOfRectangle(
        edgePoint1, edgePoint2);

    // Assert
    expect(centerPoint, equals(const Offset(20.0, 30.0)));
  });

  test('TransformationController - Calculate Region of Interest on Screen', () {
    // Arrange
    const startPoint = Offset(10.0, 20.0);
    const endPoint = Offset(30.0, 40.0);

    // Act
    final regionOfInterest =
        pkg.TransformationController.calculateRegionOfInterestOnScreen(
            startPoint, endPoint);

    // Assert
    expect(
        regionOfInterest,
        equals([
          const Offset(10.0, 20.0),
          const Offset(40.0, 20.0),
          const Offset(10.0, 60.0),
          const Offset(40.0, 60.0),
        ]));
  });

  test('TransformationController - Transform Region of Interest on Image', () {
    // Arrange
    const startPoint = Offset(10.0, 20.0);
    const endPoint = Offset(30.0, 40.0);
    const screenResolution = Size(200.0, 150.0);
    const imageResolution = Size(800.0, 600.0);

    // Act
    final transformedRegion =
        pkg.TransformationController.transformRegionOfInterestOnImage(
            startPoint, endPoint, screenResolution, imageResolution);

    // Assert
    expect(
        transformedRegion,
        equals(pkg.BoundingBox(
          topLeft: const Offset(20.0, 40.0),
          topRight: const Offset(80.0, 40.0),
          bottomLeft: const Offset(20.0, 120.0),
          bottomRight: const Offset(80.0, 120.0),
        )));
  });

  test('TransformationController - Bounding Box to Point List', () {
    // Arrange
    final boundingBox = pkg.BoundingBox(
      topLeft: const Offset(20.0, 40.0),
      topRight: const Offset(80.0, 40.0),
      bottomLeft: const Offset(20.0, 120.0),
      bottomRight: const Offset(80.0, 120.0),
    );

    // Act
    final pointList =
        pkg.TransformationController.boundingBoxToPointList(boundingBox);

    // Assert
    expect(
        pointList,
        equals([
          img.Point(20.0, 40.0),
          img.Point(80.0, 40.0),
          img.Point(80.0, 120.0),
          img.Point(20.0, 120.0),
        ]));
  });
}

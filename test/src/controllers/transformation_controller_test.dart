import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:region_of_interest/region_of_interest.dart' as pkg;

// Tests Need to be refined in upcoming patches

void main() {
  test('TransformationController - Transform Point', () {
    // Arrange
    final primaryCoordinateSystem = Size(100.0, 100.0);
    final secondaryCoordinateSystem = Size(200.0, 200.0);
    final startPoint = Offset(30.0, 40.0);

    // Act
    final transformedPoint = pkg.TransformationController.transformPoint(startPoint, primaryCoordinateSystem, secondaryCoordinateSystem);

    // Assert
    expect(transformedPoint, equals(Offset(60.0, 80.0)));
  });

  test('TransformationController - Decrease Image Ratio', () {
    // Arrange
    final originalResolution = Size(200.0, 150.0);
    final factor = 2.0;

    // Act
    final decreasedResolution = pkg.TransformationController.decreaseImageRatio(originalResolution, factor);

    // Assert
    expect(decreasedResolution, equals(Size(100.0, 75.0)));
  });

  test('TransformationController - Increase Image Ratio', () {
    // Arrange
    final originalResolution = Size(200.0, 150.0);
    final factor = 2.0;

    // Act
    final increasedResolution = pkg.TransformationController.increaseImageRatio(originalResolution, factor);

    // Assert
    expect(increasedResolution, equals(Size(400.0, 300.0)));
  });

  test('TransformationController - Calculate Center of Rectangle', () {
    // Arrange
    final edgePoint1 = Offset(10.0, 20.0);
    final edgePoint2 = Offset(30.0, 40.0);

    // Act
    final centerPoint = pkg.TransformationController.calculateCenterOfRectangle(edgePoint1, edgePoint2);

    // Assert
    expect(centerPoint, equals(Offset(20.0, 30.0)));
  });

  test('TransformationController - Calculate Region of Interest on Screen', () {
    // Arrange
    final startPoint = Offset(10.0, 20.0);
    final endPoint = Offset(30.0, 40.0);

    // Act
    final regionOfInterest = pkg.TransformationController.calculateRegionOfInterestOnScreen(startPoint, endPoint);

    // Assert
    expect(regionOfInterest, equals([
      Offset(10.0, 20.0),
      Offset(40.0, 20.0),
      Offset(10.0, 60.0),
      Offset(40.0, 60.0),
    ]));
  });

  test('TransformationController - Transform Region of Interest on Image', () {
    // Arrange
    final startPoint = Offset(10.0, 20.0);
    final endPoint = Offset(30.0, 40.0);
    final screenResolution = Size(200.0, 150.0);
    final imageResolution = Size(800.0, 600.0);

    // Act
    final transformedRegion = pkg.TransformationController.transformRegionOfInterestOnImage(startPoint, endPoint, screenResolution, imageResolution);

    // Assert
    expect(transformedRegion, equals(pkg.BoundingBox(
      topLeft: Offset(20.0, 40.0),
      topRight: Offset(80.0, 40.0),
      bottomLeft: Offset(20.0, 120.0),
      bottomRight: Offset(80.0, 120.0),
    )));
  });

  test('TransformationController - Bounding Box to Point List', () {
    // Arrange
    final boundingBox = pkg.BoundingBox(
      topLeft: Offset(20.0, 40.0),
      topRight: Offset(80.0, 40.0),
      bottomLeft: Offset(20.0, 120.0),
      bottomRight: Offset(80.0, 120.0),
    );

    // Act
    final pointList = pkg.TransformationController.boundingBoxToPointList(boundingBox);

    // Assert
    expect(pointList, equals([
      img.Point(20.0, 40.0),
      img.Point(80.0, 40.0),
      img.Point(80.0, 120.0),
      img.Point(20.0, 120.0),
    ]));
  });
}
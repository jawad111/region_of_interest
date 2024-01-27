part of region_of_interest;

/// A utility class responsible for transforming screen points to image points and performing related operations.
class TransformationController {

  /// Transforms a point from the primary coordinate system to the secondary coordinate system.
  ///
  /// [point]: The point in the primary coordinate system.
  /// [primaryCoordinateSystem]: The size of the primary coordinate system.
  /// [secondaryCoordinateSystem]: The size of the secondary coordinate system.
  static Offset transformPoint(Offset point, Size primaryCoordinateSystem, Size secondaryCoordinateSystem) {
    double primaryWidth = primaryCoordinateSystem.width;
    double primaryHeight = primaryCoordinateSystem.height;
    double secondaryWidth = secondaryCoordinateSystem.width;
    double secondaryHeight = secondaryCoordinateSystem.height;
    double transformedPointX = point.dx * (primaryWidth / secondaryWidth);
    double transformedPointY = point.dy * (primaryHeight / secondaryHeight);
    return Offset(transformedPointX, transformedPointY);
  }

  /// Decreases the image resolution by a given factor.
  static Size decreaseImageRatio(Size resolution, double factor) {
    double decreasedWidth = resolution.width / factor;
    double decreasedHeight = resolution.height / factor;
    return Size(decreasedWidth, decreasedHeight);
  }

  /// Increases the image resolution by a given factor.
  static Size increaseImageRatio(Size resolution, double factor) {
    double increasedWidth = resolution.width * factor;
    double increasedHeight = resolution.height * factor;
    return Size(increasedWidth, increasedHeight);
  }

  /// Calculates the center point of a rectangular bounding box given two edge points.
  static Offset calculateCenterOfRectangle(Offset rectangleEdgePoint1, Offset rectangleEdgePoint2) {
    double midx = (rectangleEdgePoint1.dx + rectangleEdgePoint2.dx) / 2;
    double midy = (rectangleEdgePoint1.dy + rectangleEdgePoint2.dy) / 2;
    return Offset(midx, midy);
  }

  /// Calculates the region of interest on the screen given the start and release points of a finger.
  static List<Offset> calculateRegionOfInterestOnScreen(Offset startPoint, Offset endPoint) {
    Offset topLeft = startPoint;
    Offset topRight = Offset(startPoint.dx + endPoint.dx, startPoint.dy);
    Offset bottomLeft = Offset(startPoint.dx, startPoint.dy + endPoint.dy);
    Offset bottomRight = Offset(startPoint.dx + endPoint.dx, startPoint.dy + endPoint.dy);
    return [topLeft, topRight, bottomLeft, bottomRight];
  }

  /// Converts a screen rectangular region of interest into the corresponding image's region of interest.
  static BoundingBox transformRegionOfInterestOnImage(Offset startPoint, Offset endPoint, Size screenResolution, Size imageResolution) {
    List<Offset> rectangularPointsOfRegion = calculateRegionOfInterestOnScreen(startPoint, endPoint);
    Offset topLeft = transformPoint(rectangularPointsOfRegion[0], imageResolution, screenResolution);
    Offset topRight = transformPoint(rectangularPointsOfRegion[1], imageResolution, screenResolution);
    Offset bottomLeft = transformPoint(rectangularPointsOfRegion[2], imageResolution, screenResolution);
    Offset bottomRight = transformPoint(rectangularPointsOfRegion[3], imageResolution, screenResolution);
    return BoundingBox(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft);
  }

  /// Convert from [BoundingBox] to [img.Point] data for the image package.
  static List<img.Point> boundingBoxToPointList(BoundingBox box) {
    img.Point topLeft = img.Point(box.topLeft.dx, box.topLeft.dy);
    img.Point topRight = img.Point(box.topRight.dx, box.topRight.dy);
    img.Point bottomLeft = img.Point(box.bottomLeft.dx, box.bottomLeft.dy);
    img.Point bottomRight = img.Point(box.bottomRight.dx, box.bottomRight.dy);
    return [topLeft, topRight, bottomRight, bottomLeft];
  }
}
part of region_of_interest;

class TransformationController {


  //TRANSFORM FROM PRIMARY COORDINATE SYSTEM TO SECONDARY COORDINATE SYSTEM
  transformPoint(Point point, Size primaryCoordinateSystem, Size secondaryCoordinateSystem)
  {    
    //PRIMARY COORDINATE SYSTEM
    double primaryWidth = primaryCoordinateSystem.width;
    double primaryHeight = primaryCoordinateSystem.height;
    //SECONDARY COORDINATE SYSTEM
    double secondaryWidth = secondaryCoordinateSystem.width;
    double secondaryHeight = secondaryCoordinateSystem.height;
    //APPLY TRANSFORMATION
    double transformedPointX = point.x * (primaryWidth/secondaryWidth);
    double transformedPointY = point.y * (primaryHeight/secondaryHeight);
    return [transformedPointX, transformedPointY];
  }

  //DECREASE IMAGE SIZE
  Size decreaseImageRatio(Size resolution, double factor){
    double decreasedWidth = resolution.width / factor;
    double decreasedHeight  = resolution.height / factor;
    return Size(decreasedWidth, decreasedHeight);
  }

  //INCREASE IMAGE SIZE
  Size increaseImageRatio(Size resolution, double factor){
    double increasedWidth = resolution.width / factor;
    double increasedHeight  = resolution.height / factor;
    return Size(increasedWidth, increasedHeight);
  }
  
  //CALCULATE CENTER POINT OF THE RECTANGULAR BOUNDING BOX
  Point calculateCenterOfRectangle(Point rectangleEdgePoint1, Point rectangleEdgePoint2){
    double midx = (rectangleEdgePoint1.x + rectangleEdgePoint2.x ) / 2;
    double midy = (rectangleEdgePoint1.y + rectangleEdgePoint2.y ) / 2;
    return Point(x: midx, y: midy);
  }

  //PASS IN START POINT(FIRST SCREEN TOUCH POINT) AND RELEASE POINT OF FINGER
  List<Point> calculateRegionOfIntresetOnScreen(Point startPoint, Point endPoint){
    Point topLeft = startPoint;
    Point topRight = Point(x: startPoint.x + endPoint.x, y: startPoint.y);
    Point bottomLeft = Point(x: startPoint.x, y: startPoint.y + endPoint.y);
    Point bottomRight = Point(x: startPoint.x + endPoint.x, y: startPoint.y + endPoint.y);
    List<Point> regionOfIntrest = [topLeft, topRight, bottomLeft, bottomRight];
    return regionOfIntrest;
  }

  //CONVERT SCREEN RECTANGULAR REGION OF INTREST INTO CORRESPONDING IMAGE'S REGION OF INTRESET 
  List<Point> transformRegionOfIntrestOnImage(Point startPoint, Point endPoint, Size screenResolution, Size imageResolution){
    List<Point> rectangularPointsOfSignatureRegion = calculateRegionOfIntresetOnScreen(startPoint, endPoint);
    Point topLeft = transformPoint(rectangularPointsOfSignatureRegion[0], imageResolution, screenResolution);
    Point topRight = transformPoint(rectangularPointsOfSignatureRegion[1], imageResolution, screenResolution);
    Point bottomLeft = transformPoint(rectangularPointsOfSignatureRegion[2], imageResolution, screenResolution);
    Point bottomRight = transformPoint(rectangularPointsOfSignatureRegion[3], imageResolution, screenResolution);
    List<Point> transformedRegionOfIntrest = [topLeft, topRight, bottomLeft, bottomRight];
    return transformedRegionOfIntrest;
  }





 


}
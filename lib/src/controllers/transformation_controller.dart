part of region_of_interest;

class TransformationController {


  //TRANSFORM FROM PRIMARY COORDINATE SYSTEM TO SECONDARY COORDINATE SYSTEM
  static img.Point transformPoint(img.Point point, Size primaryCoordinateSystem, Size secondaryCoordinateSystem)
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
    return img.Point(transformedPointX, transformedPointY);
  }

  //DECREASE IMAGE SIZE
  static Size decreaseImageRatio(Size resolution, double factor){
    double decreasedWidth = resolution.width / factor;
    double decreasedHeight  = resolution.height / factor;
    return Size(decreasedWidth, decreasedHeight);
  }

  //INCREASE IMAGE SIZE
  static Size increaseImageRatio(Size resolution, double factor){
    double increasedWidth = resolution.width / factor;
    double increasedHeight  = resolution.height / factor;
    return Size(increasedWidth, increasedHeight);
  }
  
  //CALCULATE CENTER POINT OF THE RECTANGULAR BOUNDING BOX
  static img.Point calculateCenterOfRectangle(img.Point rectangleEdgePoint1, img.Point rectangleEdgePoint2){
    double midx = (rectangleEdgePoint1.x + rectangleEdgePoint2.x ) / 2;
    double midy = (rectangleEdgePoint1.y + rectangleEdgePoint2.y ) / 2;
    return img.Point(midx, midy);
  }

  //PASS IN START POINT(FIRST SCREEN TOUCH POINT) AND RELEASE POINT OF FINGER
  static List<img.Point> calculateRegionOfIntresetOnScreen(img.Point startPoint, img.Point endPoint){
    img.Point topLeft = startPoint;
    img.Point topRight = img.Point(startPoint.x + endPoint.x, startPoint.y);
    img.Point bottomLeft = img.Point(startPoint.x, startPoint.y + endPoint.y);
    img.Point bottomRight = img.Point(startPoint.x + endPoint.x, startPoint.y + endPoint.y);
    List<img.Point> regionOfIntrest = [topLeft, topRight, bottomLeft, bottomRight];
    return regionOfIntrest;
  }

  //CONVERT SCREEN RECTANGULAR REGION OF INTREST INTO CORRESPONDING IMAGE'S REGION OF INTRESET 
  static List<img.Point> transformRegionOfIntrestOnImage(img.Point startPoint, img.Point endPoint, Size screenResolution, Size imageResolution){
    List<img.Point> rectangularPointsOfRegion = calculateRegionOfIntresetOnScreen(startPoint, endPoint);
    img.Point topLeft = transformPoint(rectangularPointsOfRegion[0], imageResolution, screenResolution);
    img.Point topRight = transformPoint(rectangularPointsOfRegion[1], imageResolution, screenResolution);
    img.Point bottomLeft = transformPoint(rectangularPointsOfRegion[2], imageResolution, screenResolution);
    img.Point bottomRight = transformPoint(rectangularPointsOfRegion[3], imageResolution, screenResolution);
    List<img.Point> transformedRegionOfIntrest = [topLeft, topRight, bottomRight, bottomLeft];
    return transformedRegionOfIntrest;
  }





 


}
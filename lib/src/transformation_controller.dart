part of region_of_intrest;

class TransformationController {

  //TRANSFORM FROM SECONDARY COORDINATE SYSTEM TO PRIMARY COORDINATE SYSTEM : Primary: imageResolution , Secondary : ScreenResolution
  transformPoint(List<double> point, List<double> primaryCoordinateSystem, List<double> secondaryCoordinateSystem)
  {    

    //PRIMARY COORDINATE SYSTEM
    double primaryWidth = primaryCoordinateSystem[0];
    double primaryHeight = primaryCoordinateSystem[1];

    //SECONDARY COORDINATE SYSTEM
    double secondaryWidth = secondaryCoordinateSystem[0];
    double secondaryHeight = secondaryCoordinateSystem[1];

    //APPLY TRANSFORMATION
    double transformedPointX = point[0] * (primaryWidth/secondaryWidth);
    double transformedPointY = point[1] * (primaryHeight/secondaryHeight);

    return [transformedPointX, transformedPointY];
  }

}
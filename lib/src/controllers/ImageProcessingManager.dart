part of region_of_interest;



/// Signature for a function which is called when the region is defined on camera view
typedef OnImageCaptured = void Function(
  Uint8List orignalImage, 
  Uint8List imageWithBoundingBox, 
  BoundingBox regionOfIntrest
);

class ImageProcessingManager {
  
  static process(XFile image, Map<String, double> positionOnScreen, Size screenDisplaySize, OnImageCaptured callback) async{
    //Read bytes of saved image
    Uint8List rawImageBytes = await File(image?.path ?? "").readAsBytes();

    // Define Screen Start Interaction and End Interaction points
    Offset rectangleStartPoint = Offset(positionOnScreen['x'] ?? 0.0, positionOnScreen['y'] ?? 0.0);
    Offset rectangleEndPoint = Offset(positionOnScreen['w'] ?? 0.0, positionOnScreen['h'] ?? 0.0);
    
    // Get Captured Image Size
    Size capturedImageSize = await ImageController.getImageSizeFromBytes(rawImageBytes);

    
    // Mathmatically Transform Region Points defined on Device Screen to Actual Image
    // Convertion uses coordinate transformation to translate Region Points from Display Coordinated to Image Coordinated
    BoundingBox rectanglePoints = TransformationController.transformRegionOfInterestOnImage(rectangleStartPoint, rectangleEndPoint, screenDisplaySize, capturedImageSize);

    // Draw bounding box on image bytes
    Uint8List imageBytesWithRegion = await ImageController.drawOnImage(
      image ?? XFile(""),
      rectanglePoints
    );

    //Convert bytes to MemoryImage as an ImageProvider for user
    //MemoryImage rawImage = await ImageController.uint8ListToMemoryImage(rawImageBytes);
    //MemoryImage imageWithRegion = await ImageController.uint8ListToMemoryImage(imageBytesWithRegion);


    //Pass data to Callback Function defined by user
    callback(rawImageBytes, imageBytesWithRegion, rectanglePoints);

  }
}
part of region_of_interest;

/// Signature for a function which is called when the region is defined on camera view
typedef OnImageCaptured = void Function(
  Uint8List orignalImage, 
  Uint8List imageWithBoundingBox, 
  BoundingBox regionOfInterest
);

/// A manager class responsible for processing captured images and handling bounding box calculations.
class ImageProcessingManager {
  
  /// Processes the captured image, calculates the bounding box, and invokes the user-defined callback.
  ///
  /// [image]: The captured image file.
  /// [positionOnScreen]: The position information of the bounding box on the screen.
  /// [screenDisplaySize]: The size of the screen display.
  /// [callback]: The user-defined callback function to handle the processed image data.
  static process(XFile image, Map<String, double> positionOnScreen, Size screenDisplaySize, OnImageCaptured callback) async {
    // Read bytes of the saved image
    Uint8List rawImageBytes = await File(image?.path ?? "").readAsBytes();

    // Define Screen Start Interaction and End Interaction points
    Offset rectangleStartPoint = Offset(positionOnScreen['x'] ?? 0.0, positionOnScreen['y'] ?? 0.0);
    Offset rectangleEndPoint = Offset(positionOnScreen['w'] ?? 0.0, positionOnScreen['h'] ?? 0.0);
    
    // Get Captured Image Size
    Size capturedImageSize = await ImageController.getImageSizeFromBytes(rawImageBytes);

    // Mathematically Transform Region Points defined on Device Screen to Actual Image
    // Conversion uses coordinate transformation to translate Region Points from Display Coordinates to Image Coordinates
    BoundingBox rectanglePoints = TransformationController.transformRegionOfInterestOnImage(
      rectangleStartPoint, rectangleEndPoint, screenDisplaySize, capturedImageSize
    );

    // Draw bounding box on image bytes
    Uint8List imageBytesWithRegion = await ImageController.drawOnImage(image ?? XFile(""), rectanglePoints);

    // Pass data to Callback Function defined by the user
    callback(rawImageBytes, imageBytesWithRegion, rectanglePoints);
  }
}
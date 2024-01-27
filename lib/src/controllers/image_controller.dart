part of region_of_interest;

/// A utility class responsible for manipulating images and retrieving image information.
class ImageController {

  /// Retrieves image information asynchronously.
  ///
  /// [image]: The image for which information needs to be retrieved.
  static Future<ImageInfo> getImageInformation(Image image) {
    Completer<ImageInfo> completer = Completer();
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          completer.complete(image);
        },
      ),
    );
    return completer.future;
  }

  /// Retrieves the size of an image asynchronously.
  ///
  /// [image]: The image for which the size needs to be retrieved.
  static Future<Size> getImageSize(Image image) async {
    ImageInfo imageInformation = await getImageInformation(image);
    return Size(imageInformation.image.width.toDouble(), imageInformation.image.height.toDouble());
  }

  /// Converts a Uint8List to a MemoryImage.
  ///
  /// [uint8List]: The Uint8List representing the image data.
  static Future<MemoryImage> uint8ListToMemoryImage(Uint8List uint8List) async {
    // Convert Uint8List to ByteData
    ByteData byteData = ByteData.view(uint8List.buffer);

    // Decode Image
    ui.Codec codec = await ui.instantiateImageCodec(uint8List);

    // Convert to FrameInfo
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Extract ui.Image from FrameInfo
    ui.Image uiImage = frameInfo.image;

    // Convert ui.Image to ByteData
    ByteData? byteDataFromImage = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List imageData = byteDataFromImage!.buffer.asUint8List();

    // Create MemoryImage from Uint8List
    MemoryImage memoryImage = MemoryImage(imageData);

    return memoryImage;
  }

  /// Retrieves the size of an image from a list of bytes asynchronously.
  ///
  /// [bytes]: The list of bytes representing the image data.
  static Future<Size> getImageSizeFromBytes(List<int> bytes) async {
    ui.Image decodedImg = await decodeImageFromList(Uint8List.fromList(bytes));
    return Size(decodedImg.width.toDouble(), decodedImg.height.toDouble());
  }

  /// Draws a bounding box on an image and returns the modified image as Uint8List.
  ///
  /// [xFile]: The XFile representing the image file.
  /// [rectanglePoints]: The bounding box coordinates.
  static Future<Uint8List> drawOnImage(XFile xFile, BoundingBox rectanglePoints) async {
    // Read the image file
    List<int> bytes = await File(xFile.path).readAsBytes();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    //Bounding box to list of img.Point
    List<img.Point> polygonPoints =  TransformationController.boundingBoxToPointList(rectanglePoints);

    // Perform drawing operations on the image
    img.drawPolygon(image, vertices: polygonPoints,  color: img.ColorRgb8(0, 255, 0), thickness: 5); // Green line

    // Convert the modified image to Uint8List
    Uint8List? modifiedImageData = img.encodePng(image);

    return modifiedImageData;
  }
}
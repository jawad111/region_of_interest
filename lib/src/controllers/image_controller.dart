part of region_of_interest;

class ImageController{

  static Future<ImageInfo> getImageInformation(Image image){
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

  static Future<Size> getImageSize(Image image) async{
    ImageInfo imageInformation = await getImageInformation(image);
    return Size(imageInformation.image.width.toDouble(), imageInformation.image.height.toDouble());
  }

  // Function to convert Uint8List to Image
  // Function to convert Uint8List to MemoryImage
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

  static Future<Size> getImageSizeFromBytes(List<int> bytes) async{
    ui.Image decodedImg = await decodeImageFromList(Uint8List.fromList(bytes));
    return Size(decodedImg.width.toDouble(), decodedImg.height.toDouble());
  }

  static Future<Uint8List> drawOnImage(XFile xFile , List<img.Point> rectanglePoints) async {
    // Read the image file
    List<int> bytes = await File(xFile.path).readAsBytes();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    
    // Perform drawing operations on the image
    img.drawPolygon(image, vertices: rectanglePoints,  color: img.ColorRgb8(0, 255, 0), thickness: 5); // Green line

    // Convert the modified image to Uint8List
    Uint8List? modifiedImageData = img.encodePng(image);

    return modifiedImageData;
  }

 
}
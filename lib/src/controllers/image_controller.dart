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

  static Future<Size> getImageSizeFromBytes(List<int> bytes) async{
    ui.Image decodedImg = await decodeImageFromList(Uint8List.fromList(bytes));
    return Size(decodedImg.width.toDouble(), decodedImg.height.toDouble());
  }

  static Future<ui.Image> xFileToImage(XFile xfileImage) async {
    final ByteData data = await rootBundle.load(xfileImage.path);
    final List<int> bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes as Uint8List);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  static Future<ui.Image?> drawOnImage(ui.Image image) async {
    Completer<ui.Image> completer = Completer<ui.Image>();

    final ByteData? bytes = await image.toByteData(format: ImageByteFormat.rawRgba);

    bytes?.setUint32(0, 0xFF0000FF);

    final x = 10;
    final y = 10;
    bytes?.setUint32((y * image.width + x) * 4, 0x00FF00FF);

    decodeImageFromPixels(
      bytes?.buffer.asUint8List() ?? Uint8List(0),
      image.width,
      image.height,
      ui.PixelFormat.rgba8888,
      (ui.Image result) {
        completer.complete(result);
      },
    );

    return completer.future;
}

 
}
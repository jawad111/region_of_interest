part of region_of_interest;

class ImageController{

  Future<ImageInfo> getImageInformation(Image image){
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

  Future<Size> getImageSize(Image image) async{
    ImageInfo imageInformation = await getImageInformation(image);
    return Size(imageInformation.image.width.toDouble(), imageInformation.image.height.toDouble());
  }

  Future<ui.Image> xFileToImage(String xfileImagePath) async {
    final ByteData data = await rootBundle.load(xfileImagePath);
    final List<int> bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes as Uint8List);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  Future<ui.Image?> drawOnImage(ui.Image image) async {
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
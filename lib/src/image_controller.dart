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
}
part of region_of_interest;

/// A versatile widget for displaying images with customization options.
class DisplayPictureScreen extends StatelessWidget {
  /// The image provider for the displayed image.
  final ImageProvider<Object> imageProvider;

  /// The title displayed in the app bar.
  final String title;

  /// The height of the app bar.
  final double toolBarHeight;

  /// The BoxFit for how the image should be inscribed into the container.
  final BoxFit fit;

  /// Creates a [DisplayPictureScreen] widget.
  ///
  /// [imageProvider]: The image provider for the displayed image.
  /// [title]: The title displayed in the app bar.
  /// [toolBarHeight]: The height of the app bar.
  /// [fit]: The BoxFit for how the image should be inscribed into the container.
  const DisplayPictureScreen({
    Key? key,
    required this.imageProvider,
    this.title = 'Capture',
    this.toolBarHeight = 50.0,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: toolBarHeight,
          title: Text(title),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image(image: imageProvider, fit: fit),
        ),
      ),
    );
  }
}

part of region_of_interest;

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;

  // Holds the position information of the BoundingBox
  Map<String, double> _position = {
    'x': 0,
    'y': 0,
    'w': 0,
    'h': 0,
  };

  // Toggle BoundingBox display
  bool _boundingBoxVisible = false;

  //Initial Tap Positions
  double initialXPosition = 0.0;
  double initialYPosition = 0.0;

  //Subtract with Non-Negative Result
  double getEndPositionOfRegion(double newPosition, double initialPosition) {
    double endPosition = newPosition - initialPosition;
    return endPosition < 0 ? 0.0 : endPosition;
  }

  //Update Region Bottom-Right Point
  void updateRegionPosition(double updatedPositionX, double updatedPositionY) {
    setState(() {
      // assign new position
      _position = {
        'x': initialXPosition,
        'y': initialYPosition,
        'w': getEndPositionOfRegion(updatedPositionX, initialXPosition),
        'h': getEndPositionOfRegion(updatedPositionY, initialYPosition),
      };
      _boundingBoxVisible = true;
    });
  }


  Future<Uint8List?> drawOnImage(XFile imageFile) async {
    // Read the image file
    List<int> bytes = await File(imageFile.path).readAsBytes();
    img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

    // Perform your drawing operations on the image
    img.drawLine(image, x1:10, x2:300, y1:10, y2:300,  color: img.ColorRgb8(255, 0, 0), thickness: 7); // Red line

    // Convert the modified image to Uint8List
    Uint8List? modifiedImageData = img.encodePng(image);

    return modifiedImageData;
    // Save the modified image to a new file
    // String fileName = imageFile.path.split('/').last;
    // String directory = (await getApplicationDocumentsDirectory()).path;
    // String newPath = '$directory/drawn_$fileName';
    // File newImageFile = File(newPath);
    // await newImageFile.writeAsBytes(byteData!.buffer.asUint8List());

    // // Now, 'newPath' contains the path to the modified image
    // print('Modified image saved at: $newPath');
  }


  //Take Picture Function
  Future<XFile?> takePicture() async {
    // Provide an onPressed callback.

    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      if (!_cameraController.value.isInitialized) return null;
      // Attempt to take a picture and then get the location
      // where the image file is saved.
      final image = await _cameraController.takePicture();
      return image;
      ;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    // create a CameraController
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    // Next, initialize the controller. This returns a Future.
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  Future<ui.Image> convertImage(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final List<int> bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes as Uint8List);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return _cameraController.value.isInitialized
        ? SafeArea(
          child: Scaffold(
              body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: InteractiveViewer(
                    onInteractionStart: (details) {
                      initialXPosition = details.focalPoint.dx;
                      initialYPosition = details.focalPoint.dy;
                    },
                    onInteractionUpdate: (details) {
                      updateRegionPosition(
                          details.focalPoint.dx, details.focalPoint.dy);
                    },
                    onInteractionEnd: (details) async {
                      XFile? image = await takePicture();
                      final bytes = await File(image?.path ?? "").readAsBytes();

                      
                      
                      //Draw on image
                      final drawByteData = await drawOnImage(image ?? XFile(""));


                       if (image != null) {
                        // If the picture was taken, display it on a new screen.
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BytesImageView(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            pngBytes: drawByteData ,
        
                            // // Pass bounding box position to overlay on top
                            // boundingBoxPosition: _position,
                          ),
                        ));
                      }
        
                      // if (image != null) {
                      //   // If the picture was taken, display it on a new screen.
                      //   await Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => DisplayPictureScreen(
                      //       // Pass the automatically generated path to
                      //       // the DisplayPictureScreen widget.
                      //       imagePath: image.path,
        
                      //       // Pass bounding box position to overlay on top
                      //       boundingBoxPosition: _position,
                      //     ),
                      //   ));
                      // }
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        _cameraController == null
                            ? Container()
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: CameraPreview(_cameraController)),
                        if (_boundingBoxVisible)
                          Positioned(
                            left: _position['x'],
                            top: _position['y'],
                            child: InkWell(
                              onTap: () {
                                //TAP TO HIDE REGION
                                setState(() {
                                  _boundingBoxVisible = false;
                                });
                              },
                              child: Container(
                                width: _position['w'],
                                height: _position['h'],
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.green,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    color: Colors.green,
                                    child: Text(
                                      'ITEM',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
            ),
        )
        : const Center(child: CircularProgressIndicator());
  }
}

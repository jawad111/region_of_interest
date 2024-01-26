part of region_of_interest;

// A screen that allows users to define rectangle and take a picture using a given camera.
class DefineRegionScreen extends StatefulWidget {
  final CameraDescription camera;
  final Function callback;
  const DefineRegionScreen({Key? key, required this.camera, required this.callback}) : super(key: key);
  @override
  State<DefineRegionScreen> createState() => _DefineRegionScreenState();
}

class _DefineRegionScreenState extends State<DefineRegionScreen> {
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

  // Initial Tap Positions
  double initialXPosition = 0.0;
  double initialYPosition = 0.0;

  // Subtract with Non-Negative Result
  double getEndPositionOfRegion(double newPosition, double initialPosition) {
    double endPosition = newPosition - initialPosition;
    return endPosition < 0 ? 0.0 : endPosition;
  }

  // Update Region Bottom-Right Point
  void updateRegionPosition(double updatedPositionX, double updatedPositionY) {
    setState(() {
      // Assign new position
      _position = {
        'x': initialXPosition,
        'y': initialYPosition,
        'w': getEndPositionOfRegion(updatedPositionX, initialXPosition),
        'h': getEndPositionOfRegion(updatedPositionY, initialYPosition),
      };
      _boundingBoxVisible = true;
    });
  }

  // Take Picture Function
  Future<XFile?> takePicture() async {
    try {
      // Ensure that the camera is initialized.
      if (!_cameraController.value.isInitialized) return null;
      
      // Attempt to take a picture and then get the location
      // where the image file is saved.
      final image = await _cameraController.takePicture();
      return image;
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  // Initialize Camera Function
  Future initCamera(CameraDescription cameraDescription) async {

    //Initialize Camera Controller
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

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
    // Initialize the given camera
    initCamera(widget.camera);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
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
                    //Take A picture
                    XFile? image = await takePicture();

                    //Read bytes of saved image
                    Uint8List rawImageBytes = await File(image?.path ?? "").readAsBytes();

                    // Define Screen Start Interaction and End Interaction points
                    img.Point rectangleStartPoint = img.Point(_position['x'] ?? 0.0, _position['y'] ?? 0.0);
                    img.Point rectangleEndPoint = img.Point(_position['w'] ?? 0.0, _position['h'] ?? 0.0);
                    
                    // Get Captured Image Size
                    Size capturedImageSize = await ImageController.getImageSizeFromBytes(rawImageBytes);

                    // Get Device Layout Screen Size
                    Size screenDisplaySize = Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height);

                    // Mathmatically Transform Region Points defined on Device Screen to Actual Image
                    // Convertion uses coordinate transformation to translate Region Points from Display Coordinated to Image Coordinated
                    List<img.Point> rectanglePoints = TransformationController.transformRegionOfIntrestOnImage(rectangleStartPoint, rectangleEndPoint, screenDisplaySize, capturedImageSize);

                    // Draw bounding box on image bytes
                    Uint8List imageBytesWithRegion = await ImageController.drawOnImage(
                      image ?? XFile(""),
                      rectanglePoints
                    );

                    //Convert bytes to MemoryImage as an ImageProvider for user
                    MemoryImage rawImage = await ImageController.uint8ListToMemoryImage(rawImageBytes);
                    MemoryImage imageWithRegion = await ImageController.uint8ListToMemoryImage(imageBytesWithRegion);


                    //Pass data to Callback Function defined by user
                    widget.callback(context, rawImage, imageWithRegion, rectanglePoints);

                    
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      _cameraController == null
                          ? Container()
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: CameraPreview(_cameraController),
                            ),
                      if (_boundingBoxVisible)
                        Positioned(
                          left: _position['x'],
                          top: _position['y'],
                          child: InkWell(
                            onTap: () {
                              // TAP TO HIDE REGION
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
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
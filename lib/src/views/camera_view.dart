part of region_of_interest;

// A screen that allows users to take a picture using a given camera.
class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({Key? key, required this.cameras}) : super(key: key);
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
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
  double getEndPositionOfRegion(double newPosition, double initialPosition){
    double endPosition = newPosition - initialPosition;
    return endPosition < 0 ? 0.0 : endPosition;
  }

  //Update Region Bottom-Right Point
  void updateRegionPosition(
      double updatedPositionX, double updatedPositionY) {
    setState(() {
      // assign new position
      _position = {
        'x': initialXPosition,
        'y': initialYPosition,
        'w': getEndPositionOfRegion(updatedPositionX,initialXPosition),
        'h': getEndPositionOfRegion(updatedPositionY,initialYPosition),
      };
      _boundingBoxVisible = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return _cameraController.value.isInitialized
        ? Container(
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
                            // When the user taps on the rectangle, it will disappear
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
              )
            
          )
        : const Center(child: CircularProgressIndicator());
  }
}

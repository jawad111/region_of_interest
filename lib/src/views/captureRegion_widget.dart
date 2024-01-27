part of region_of_interest;

/// A widget that allows users to define a rectangular region and capture a picture using a given camera.
class CaptureRegionWidget extends StatefulWidget {
  /// The description of the camera to be used.
  final CameraDescription camera;

  /// Callback function that is called when an image is captured with the defined region.
  final OnImageCaptured callback;

  /// Creates a [CaptureRegionWidget] widget.
  ///
  /// The [camera] parameter is required and represents the description of the camera to be used.
  /// The [callback] parameter is required and is a callback function that is invoked when an image
  /// is captured with the defined region.
  const CaptureRegionWidget({Key? key, required this.camera, required this.callback}) : super(key: key);

  @override
  State<CaptureRegionWidget> createState() => _CaptureRegionWidgetState();
}

class _CaptureRegionWidgetState extends State<CaptureRegionWidget> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  /// Initialize the camera.
  Future<void> initCamera(CameraDescription cameraDescription) async {
    // Initialize Camera Controller
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeCameraControllerFuture = _cameraController.initialize();
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
    return FutureBuilder<void>(
      future: _initializeCameraControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Preview(cameraController: _cameraController, callback: widget.callback);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
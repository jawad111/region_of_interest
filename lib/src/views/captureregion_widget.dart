// Copyright (c) 2024, Jawad Bhatti. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of region_of_interest;

/// A comprehensive widget for capturing images within a user-defined rectangular region.
///
/// This widget serves as the primary entry point for users, allowing them to interact with
/// the camera, define a rectangular region of interest, and capture images within that region.
///
/// Users need to provide the [camera] description, specifying the camera to be utilized,
/// and a [callback] function, which is invoked when an image is captured within the defined region.
class CaptureRegionWidget extends StatefulWidget {
  /// The description of the camera to be used.
  final CameraDescription camera;

  /// Callback function invoked when an image is captured within the defined region.
  final OnImageCaptured callback;

  /// Creates a [CaptureRegionWidget] instance.
  ///
  /// The [camera] parameter is required and represents the description of the camera to be used.
  ///
  /// The [callback] parameter is required and is a callback function that is invoked when an image
  /// is captured with the defined region.
  const CaptureRegionWidget(
      {Key? key, required this.camera, required this.callback})
      : super(key: key);

  @override
  State<CaptureRegionWidget> createState() => _CaptureRegionWidgetState();
}

class _CaptureRegionWidgetState extends State<CaptureRegionWidget> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  /// Initialize the camera and prepare for image capturing.
  Future<void> initCamera(CameraDescription cameraDescription) async {
    // Initialize Camera Controller
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
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
          return Preview(
              cameraController: _cameraController, callback: widget.callback);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

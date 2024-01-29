// Copyright (c) 2024, Jawad Bhatti. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of region_of_interest;

/// A widget that provides a live camera preview with the ability to define a rectangular region.
class Preview extends StatefulWidget {
  /// The controller for the camera.
  final CameraController cameraController;

  /// Callback function that is called when an image is captured with the defined region.
  final OnImageCaptured callback;

  /// Creates a [Preview] widget.
  ///
  /// The [cameraController] parameter is required and represents the controller for the camera.
  /// The [callback] parameter is required and is a callback function that is invoked when an image
  /// is captured with the defined region.
  const Preview(
      {Key? key, required this.cameraController, required this.callback})
      : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              try {
                // Take a picture
                XFile image = await widget.cameraController.takePicture();

                // Get Device Layout Screen Size
                Size screenDisplaySize = Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height);

                // Process Image and Pass the output to the user-defined Callback
                ImageProcessingManager.process(
                    image, _position, screenDisplaySize, widget.callback);
              } on CameraException catch (error) {
                // Handle CameraException
                CameraException(error.code, error.toString());
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CameraPreview(widget.cameraController),
                ),
                if (_boundingBoxVisible)
                  Positioned(
                    left: _position['x'],
                    top: _position['y'],
                    child: InkWell(
                      onTap: () {
                        // Tap to hide the region
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
                            child: const Text(
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
    );
  }
}

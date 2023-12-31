import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';
import 'package:region_of_interest/region_of_interest.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {

  Point interactionPoint = Point(x: 0.0, y: 0.0);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
          onInteractionUpdate: (v) {
            interactionPoint = Point(x:v.localFocalPoint.dx, y:v.localFocalPoint.dy);
          },
          child: Image.memory(Uint8List(0),
            fit: BoxFit.fitHeight,
          ),
    );
  }
}
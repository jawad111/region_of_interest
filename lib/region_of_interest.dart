// Copyright (c) 2024, Jawad Bhatti. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Capture precise regions on live camera views effortlessly. Streamline image dataset capture on mobile devices with ease using [region_of_interest] Flutter package.

library region_of_interest;

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

part 'src/controllers/transformation_controller.dart';
part 'src/controllers/image_controller.dart';
part 'src/views/captureregion_widget.dart';
part 'src/views/display_capture.dart';
part 'src/models/boundingbox_model.dart';
part 'src/controllers/imageprocessing_manager.dart';
part 'src/views/live_preview.dart';

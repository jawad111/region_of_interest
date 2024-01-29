// Copyright (c) 2024, Jawad Bhatti. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of region_of_interest;

/// Represents a bounding box with four corner points.
class BoundingBox {
  /// Top-left corner of the bounding box.
  final Offset topLeft;

  /// Top-right corner of the bounding box.
  final Offset topRight;

  /// Bottom-left corner of the bounding box.
  final Offset bottomLeft;

  /// Bottom-right corner of the bounding box.
  final Offset bottomRight;

  /// Constructs a [BoundingBox] instance with the specified corner points.
  BoundingBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  /// Creates a [BoundingBox] instance from a JSON map.
  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      topLeft: Offset(json['topLeftX'] ?? 0.0, json['topLeftY'] ?? 0.0),
      topRight: Offset(json['topRightX'] ?? 0.0, json['topRightY'] ?? 0.0),
      bottomLeft: Offset(json['bottomLeftX'] ?? 0.0, json['bottomLeftY'] ?? 0.0),
      bottomRight: Offset(json['bottomRightX'] ?? 0.0, json['bottomRightY'] ?? 0.0),
    );
  }

  /// Converts the [BoundingBox] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'topLeftX': topLeft.dx,
      'topLeftY': topLeft.dy,
      'topRightX': topRight.dx,
      'topRightY': topRight.dy,
      'bottomLeftX': bottomLeft.dx,
      'bottomLeftY': bottomLeft.dy,
      'bottomRightX': bottomRight.dx,
      'bottomRightY': bottomRight.dy,
    };
  }
}
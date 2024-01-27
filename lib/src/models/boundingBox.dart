part of region_of_interest;


class BoundingBox {
  final Offset topLeft;     // Top-left corner
  final Offset topRight;    // Top-right corner
  final Offset bottomLeft;  // Bottom-left corner
  final Offset bottomRight; // Bottom-right corner

  BoundingBox({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      topLeft: Offset(json['topLeftX'] ?? 0.0, json['topLeftY'] ?? 0.0),
      topRight: Offset(json['topRightX'] ?? 0.0, json['topRightY'] ?? 0.0),
      bottomLeft: Offset(json['bottomLeftX'] ?? 0.0, json['bottomLeftY'] ?? 0.0),
      bottomRight: Offset(json['bottomRightX'] ?? 0.0, json['bottomRightY'] ?? 0.0),
    );
  }

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
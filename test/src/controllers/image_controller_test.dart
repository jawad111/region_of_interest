import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:region_of_interest/region_of_interest.dart';


// Tests Need to be refined in upcoming patches

Future<Uint8List> mockImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image. HTTP Status Code: ${response.statusCode}');
        return Uint8List(0);
      }
    } catch (error) {
      print('Error loading image: $error');
      return Uint8List(0);
    }
  }

void main() {
  group('ImageController Tests', () {
    test('getImageInformation should complete with ImageInfo', () async {
      // Arrange
      final Uint8List imageBytes = await mockImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");
      final Image image = Image.memory(imageBytes);

      // Act
      final result = await ImageController.getImageInformation(image);

      // Assert
      expect(result, isA<ImageInfo>());
    });

    test('getImageSize should complete with Size', () async {
      // Arrange
      // Arrange
      final Uint8List imageBytes = await mockImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");
      final Image image = Image.memory(imageBytes);

      // Act
      final result = await ImageController.getImageSize(image);

      // Assert
      expect(result, isA<Size>());
    });

    test('uint8ListToMemoryImage should complete with MemoryImage', () async {
      // Arrange
      final uint8List = Uint8List.fromList([1, 2, 3]);

      // Act
      final result = await ImageController.uint8ListToMemoryImage(uint8List);

      // Assert
      expect(result, isA<MemoryImage>());
    });

    test('getImageSizeFromBytes should complete with Size', () async {
      // Arrange
      final bytes = Uint8List.fromList([1, 2, 3]);

      // Act
      final result = await ImageController.getImageSizeFromBytes(bytes);

      // Assert
      expect(result, isA<Size>());
    });

    test('drawOnImage should complete with Uint8List', () async {
      // Arrange
      final XFile xFile  = XFile("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png");
      final boundingBox = BoundingBox(
        topLeft: Offset(0, 0),
        topRight: Offset(1, 0),
        bottomLeft: Offset(0, 1),
        bottomRight: Offset(1, 1),
      );

      // Act
      final result = await ImageController.drawOnImage(xFile, boundingBox);

      // Assert
      expect(result, isA<Uint8List>());
    });
  });
}
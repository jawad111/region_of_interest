import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:region_of_interest/region_of_interest.dart';

// Tests Need to be refined in upcoming patches

void main() {
  testWidgets('DisplayPictureScreen widget displays image with correct title', (WidgetTester tester) async {
    // Create a key for finding the widget.
    const Key titleKey = Key('display_picture_title');

    // Create a MaterialApp to hold the widget.
    await tester.pumpWidget(
      const MaterialApp(
        home: DisplayPictureScreen(
          imageProvider: AssetImage('assets/test_image.jpg'),
          title: 'Test Title',
        ),
      ),
    );

    // Expect the app bar title and the image to be displayed.
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byKey(titleKey), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // You can add more expectations based on your widget's behavior.
  });
}
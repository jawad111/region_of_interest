# region_of_interest


The region_of_interest Flutter package empowers developers to effortlessly define regions of interest on a live camera view, enabling automatic calculation of precise bounding box coordinates. Designed for simplicity and versatility, this package streamlines the process of capturing image datasets easily with portable mobile devices.


## Platform Support

More platforms will be added soon!

| Android | iOS |
| :-----: | :-: | 
|   ✅    | ✅  |  

## Usage and Usecases

First import Package
```dart
import 'package:region_of_interest/region_of_interest.dart';
```


1. Basic Usage - Capturing Images with Defined Region

To capture images within a defined region on the camera view, use the CaptureRegionWidget. This widget allows users to specify the camera and callback for handling captured images and bounding box coordinates.


```dart
CaptureRegionWidget(
  camera: //provide your camera description,
  callback: (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
    // Handle the captured images and bounding box as needed
    // Example: Display images, send to server, etc.
  },
)
```


2. Sending to Server - Utilizing Captured Images and Bounding Box

```dart
CaptureRegionWidget(
  camera: //provide your camera description,
  callback: (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
    // Handle the captured images and bounding box by sending them to a server
    // Example: Send images and bounding box data to your server
    YourServerCommunication.sendData(originalImage, imageWithBoundingBox, regionOfInterest);
  },
)
```

3. Generating Dataset - Creating a Dataset on device with Original Images and Bounding Boxes

```dart
CaptureRegionWidget(
  camera: //provide your camera description,
  callback: (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
    // Handle the captured images and bounding box for generating a dataset
    // Example: Save images and bounding box coordinates for dataset creation
    YourDatasetGenerator.saveData(originalImage, regionOfInterest);
  },
)
```

4. Displaying Images - Using DisplayPictureScreen to view captured Images for Region 

```dart
CaptureRegionWidget(
  camera: //provide your camera description,
  callback: (Uint8List originalImage, Uint8List imageWithBoundingBox, BoundingBox regionOfInterest) {
    // Handle the captured images and bounding box as needed
    // Example: Display the original image and image with bounding box
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(
          originalImage: originalImage,
          imageWithBoundingBox: imageWithBoundingBox,
          boundingBox: regionOfInterest,
        ),
      ),
    );
  },
)
```

See Example for full implementation.
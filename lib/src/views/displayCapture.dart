part of region_of_interest;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, double> boundingBoxPosition;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.boundingBoxPosition});

  final double kToolBarHeight = 50;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBody: true,
        // appBar:
        //     AppBar(toolbarHeight: kToolBarHeight, title: const Text('Capture')),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.fill,
                )),
            Positioned(
              left: boundingBoxPosition['x'],
              top: boundingBoxPosition['y'],
              child: Container(
                width: boundingBoxPosition['w'],
                height: boundingBoxPosition['h'],
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
                    child: Text(
                      'ITEM',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back_rounded)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white

                      ),
                      child: Padding(
                        
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Capture', style: TextStyle(fontSize: 30),),
                      ),
                    ),
                  ),
                  Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

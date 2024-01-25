part of region_of_interest;

class BytesImageView extends StatelessWidget {
  final Uint8List? pngBytes;

  const BytesImageView({Key? key, this.pngBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,

      child: Image.memory(pngBytes ?? Uint8List(0), fit: BoxFit.fill,),
    ));
  }
}
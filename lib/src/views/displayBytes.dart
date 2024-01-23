part of region_of_interest;

class BytesImageView extends StatelessWidget {
  final dynamic pngBytes;

  const BytesImageView({Key? key, this.pngBytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      child: Image.memory(Uint8List.view(pngBytes.buffer)),
    ));
  }
}
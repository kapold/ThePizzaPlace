import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

class ImageContainer extends StatefulWidget {
  final String imageLocator;

  ImageContainer({required this.imageLocator});

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  String imageUrl = "";
  Future<String> _getImageUrl() async {
    String img = "";
    FirebaseStorage.instance.ref().child(widget.imageLocator).getDownloadURL().then((value){
      img = value;
    });
    return img;
  }

  @override
  void initState() {
    super.initState();
    _getImageUrl().then((value){
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ImageNetwork(
        image: imageUrl,
        height: 150,
        width: 150
    );
  }
}

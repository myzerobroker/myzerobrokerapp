import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryImagePicker extends StatefulWidget {
  final Function(List<File>) onImagesPicked;

  const GalleryImagePicker({required this.onImagesPicked, Key? key}) : super(key: key);

  @override
  _GalleryImagePickerState createState() => _GalleryImagePickerState();
}

class _GalleryImagePickerState extends State<GalleryImagePicker> {
  @override
  void initState() {
    // TODO: implement initState
    _images.clear();
    super.initState();
  }
  
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((e) => File(e.path)).toList();
      });
      widget.onImagesPicked(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        InkWell(
          onTap: _pickImages, 
          child: Center(
            child: Image.asset(
              "assets/images/ImagePicker-removebg-preview.png",
              height: height * 0.2,
              width: width * 0.4,
            ),
          ),
        ),
        if (_images.isNotEmpty)
          Column(
            children: _images.map((image) {
              return Text(image.uri.pathSegments.last); 
            }).toList(),
          ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({Key? key, required this.imagePickingFunction})
      : super(key: key);
  final void Function(File pickedImage) imagePickingFunction;
  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
      imageQuality: 60,
    );
    setState(() {
      pickedImage = File(imageFile!.path);
    });
    widget.imagePickingFunction(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage:
              pickedImage == null ? null : FileImage(File(pickedImage!.path)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image),
            TextButton(onPressed: _pickImage, child: const Text('Add Image')),
          ],
        ),
      ],
    );
  }
}

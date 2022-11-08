// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;
  const UserImagePicker({Key? key,required this.imagePickFn}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;
  void _pickImage()async{
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    setState(() {
      _pickedImage = File(pickedImageFile!.path) ;
    });
    widget.imagePickFn(_pickedImage!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         CircleAvatar(
          backgroundImage:_pickedImage != null ?  FileImage(_pickedImage!) : null,
          radius: 40,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          onPressed: () {_pickImage();},
          label: const Text("Add Image"),
        ),
      ],
    );
  }
}

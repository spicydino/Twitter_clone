import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String getNameFromEmail(String email) {
  // Split the email by '@' and take the first part
  return email.split('@')[0];
  // String name = email.split('@')[0];
  // Replace '.' with ' ' to make it more readable
  //name = name.replaceAll('.', ' ');
  // Capitalize the first letter of each word
  //return name.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
}


Future<List<XFile>?> pickImages()  async{
  final List<XFile>? images =[];
  final ImagePicker Picker = ImagePicker();
  final ImageFile = await Picker.pickMultiImage();
  if (ImageFile.isNotEmpty) {
    for(final image in ImageFile) {
      images?.add(File(image.path) as XFile);
    }
  }
  return images;;
}
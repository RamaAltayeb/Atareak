import 'dart:io';

import 'package:atareak/views/components/dialogs.dart';
import 'package:atareak/views/utilities/assets_strings.dart';
import 'package:atareak/views/utilities/colors.dart';
import 'package:atareak/views/utilities/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ProfileImagePicker extends StatefulWidget {
  PickedFile _imageFile;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();

  String getImagePath() {
    if (_imageFile != null) {
      return _imageFile.path;
    } else {
      return null;
    }
  }
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: widget._imageFile == null
                ? const AssetImage(kImageUser)
                : FileImage(File(widget._imageFile.path)),
          ),
          Positioned(
            bottom: 18,
            left: 22,
            child: InkWell(
              onTap: () {
                imageSourceDialog();
              },
              child: const Icon(
                Icons.camera_alt_rounded,
                color: kColorWhite,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> imageSourceDialog() {
    return myDialog(
      content: Column(
        children: [
          const SizedBox(height: 20),
          TextButton.icon(
            icon: const Icon(Icons.camera_rounded, color: kColorPrimary),
            label: const Text('الكاميرا', style: kTextPrimaryStyle),
            onPressed: () {
              takePhoto(ImageSource.camera);
              Get.back();
            },
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.image_rounded, color: kColorPrimary),
            label: const Text('المعرض', style: kTextPrimaryStyle),
            onPressed: () {
              takePhoto(ImageSource.gallery);
              Get.back();
            },
          ),
          const SizedBox(height: 10),
          widget._imageFile == null
              ? const SizedBox(height: 0)
              : TextButton.icon(
                  icon: const Icon(Icons.delete_rounded, color: kColorPrimary),
                  label: const Text('أزل الصورة', style: kTextPrimaryStyle),
                  onPressed: () {
                    setState(() => widget._imageFile = null);
                    Get.back();
                  },
                ),
        ],
      ),
    );
  }

  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() => widget._imageFile = pickedFile);
  }
}

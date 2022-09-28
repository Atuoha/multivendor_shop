import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({
    Key? key,
    required this.selectImage,
    this.isReg = true,
    this.imgUrl = 'assets/images/profile.png',
  }) : super(key: key);
  final Function(File) selectImage;
  final bool isReg;
  final String imgUrl;

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

// for photo selection
enum Source { camera, gallery }

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  XFile? profileImage;
  final ImagePicker _picker = ImagePicker();

  // for selecting photo
  Future _selectPhoto(Source source) async {
    XFile? pickedImage;
    switch (source) {
      case Source.camera:
        pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 600,
          maxHeight: 600,
        );
        break;
      case Source.gallery:
        pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 600,
          maxHeight: 600,
        );
        break;
    }
    if (pickedImage == null) {
      return null;
    }

    widget.selectImage(File(pickedImage.path));

    // assign the picked image to the profileImage
    setState(() {
      profileImage = pickedImage;
    });
  }

  // widget for each profile image selector
  Widget kContainer(Source source) {
    return GestureDetector(
      onTap: () => _selectPhoto(source),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: source == Source.gallery
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
        ),
        child: Center(
          child: Icon(
            source == Source.gallery ? Icons.photo : Icons.camera_alt_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: profileImage == null ? 60 : 80,
          backgroundColor: Colors.white,
          child: Center(
            child: profileImage == null
                ? widget.isReg
                    ? Image.asset(
                        'assets/images/profile.png',
                        color: primaryColor,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(widget.imgUrl),
                      ) // this will load imgUrl from firebase
                : ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.file(
                      File(profileImage!.path),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 5),
        Column(
          children: [
            kContainer(Source.gallery),
            const SizedBox(height: 5),
            kContainer(Source.camera)
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_image/firebase_image.dart';

class ProfilePic extends StatefulWidget {
  final String email;

  ProfilePic({this.email});

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  Uint8List imageFile;
  Image image;
  StorageReference reference = FirebaseStorage.instance.ref().child("images");
//  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://eventia-pro.appspot.com');

  getImage() async {
    String userEmail = widget.email;
    int maxSize = 7 * 1024 * 1024;
    String filePath = 'images/$userEmail profilePic.png';
    reference
        .child('${userEmail}profilePic.png')
        .getData(maxSize)
        .then((value) {
      this.setState(() {
        imageFile = value;
        print('image loaded');
      });
    }).catchError((error) {
      print('bazinga');
      print(error);
    });

//    imageFile = await _storage.ref().child(filePath).getData(maxSize);
//
//    setState(() {
//      //_uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//
//    });
  }

  void getImageUsingPackage() async {
    String url =
        'gs://eventia-pro.appspot.com/images/${widget.email}profilePic.png';
    Image image = await Image(
      image: FirebaseImage(url),
    );
  }

  Widget putImage() {}
  Widget putLogo() {
    if (imageFile == null) {
      return Center(
        child: Text('No Image'),
      );
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover);
    }
  }

  @override
  void initState() {
    super.initState();
//    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return putLogo();
  }
}
//todo get images

import 'package:eventia_pro/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:eventia_pro/screens/event_manager/Uploader.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  static const id = 'image_capture';
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      toolbarColor: Colors.purple,
      toolbarWidgetColor: Colors.white,
      toolbarTitle: 'Crop It',
      statusBarColor: Colors.purple,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        // Select an image from the camera or gallery
        bottomNavigationBar: BottomAppBar(
          color: kPinkColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ),

        // Preview the image and crop it
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              if (_imageFile != null) ...[
                Image.file(_imageFile),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.crop,
                          color: kPinkColor,
                        ),
                        onPressed: _cropImage,
                      ),
                      FlatButton(
                        child: Icon(
                          Icons.refresh,
                          color: kPinkColor,
                        ),
                        onPressed: _clear,
                      ),
                    ],
                  ),
                ),
                Uploader(file: _imageFile)
              ] else ...[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Hero(
                    tag: 'logo',
                    child: Text(
                      'Pick a Profile Picture',
                      style: kBigHeadingStyle,
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

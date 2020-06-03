import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/event_manager/em_dashboard.dart';
import 'package:eventia_pro/screens/event_manager/em_degree.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({this.file});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://eventia-pro.appspot.com');
  final _auth = FirebaseAuth.instance;
  StorageUploadTask _uploadTask;

  /// Starts an upload task
  void _startUpload() async {
    FirebaseUser user = await _auth.currentUser();

    /// Unique file name for the file
    String filePath = 'images/${user.email}profilePic.png';
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_uploadTask.isComplete)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
//                      Center(
//                        child: Text(
//                          'Uploaded Succesfully',
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 20.0
//                          ),
//                        ),
//                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Hero(
                        tag: 'logo',
                        child: GenericButton(
                            onTap: () {
                              if (_uploadTask.isComplete) {
                                Navigator.popAndPushNamed(
                                    context, EmDashboard.id);
                              }
                            },
                            text: 'Next'),
                      ),
                    ],
                  ),
                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(
                      Icons.play_arrow,
                      color: kPinkColor,
                    ),
                    onPressed: _uploadTask.resume,
                  ),
                if (_uploadTask.isInProgress)
                  Column(
                    children: [
                      FlatButton(
                        child: Icon(
                          Icons.pause,
                          color: kPinkColor,
                        ),
                        onPressed: _uploadTask.pause,
                      ),

                      // Progress bar
                      LinearProgressIndicator(value: progressPercent),
                      Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                    ],
                  ),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GenericButton(
            onTap: () {
              _startUpload();
            },
            text: 'Upload'),
      );
    }
  }
}

//onPressed: _startUpload

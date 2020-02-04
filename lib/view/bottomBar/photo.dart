import 'package:camera/camera.dart';
import 'dart:async';

//Design library
import 'package:flutter/material.dart';

class PhotoPage extends StatefulWidget {
  final CameraDescription camera;

  const PhotoPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  PhotoPageState createState() => PhotoPageState();
}

class PhotoPageState extends State<PhotoPage>{
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.

    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    /*
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio:
        _controller.value.aspectRatio,
        child: CameraPreview(_controller)
    );*/
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_controller);
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


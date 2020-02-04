import 'dart:io';
import 'dart:async';

//Send image to server
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

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

class PhotoPageState extends State<PhotoPage> {
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
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Scaffold(
                body: CameraPreview(_controller),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  // Provide an onPressed callback.
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Construct the path where the image should be saved using the
                      // pattern package.
                      final path = join(
                        // Store the picture in the temp directory.
                        // Find the temp directory using the `path_provider` plugin.
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );

                      // Attempt to take a picture and log where it's been saved.
                      await _controller.takePicture(path);

                      // If the picture was taken, display it on a new screen.
                      bool result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SendingPicture(imagePath: path),
                        ),
                      );
                      if (result == true) Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Photo envoyée ! :)')));
                    } catch (e) {print(e);}
                  },
                ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}
class SendingPicture extends StatefulWidget {
  final String imagePath;
  SendingPicture({Key key, this.imagePath}) : super(key: key);

  @override
  SendingPictureState createState() => SendingPictureState();
}
// A widget that displays the picture taken by the user.
class SendingPictureState extends State<SendingPicture> {
  //To display status of sending
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) {
    Widget body = new Column(
        children: <Widget> [
          Image.file(File(widget.imagePath)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {Navigator.pop(context);},
                child: Text('Retour'),
              ),
              RaisedButton(
                onPressed: () async {
                  File file = File(widget.imagePath);
                  String phpEndPoint = 'http://minecraft.yoannchappaz.best/BA/receiveImage.php';
                  String base64Image = base64Encode(file.readAsBytesSync());
                  String fileName = file.path.split("/").last;

                  //Sending picture to server
                  http.Response res = await http.post(phpEndPoint, body: {
                    "image": base64Image,
                    "name": fileName,
                  }).catchError((e){Scaffold.of(_scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Une erreur est survenue lors de l\'envoi...\nRéessayez à nouveau')));
                  });
                  //Check result
                  if (res.statusCode == 200){
                    Scaffold.of(_scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Photo envoyée ! :)')));
                    Navigator.pop(context, true);
                  }
                  else Scaffold.of(_scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Erreur lors de l\'envoi...\nRéessayez à nouveau')));
                },
                child: Text('Envoyer'),
              ),
            ],
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(title: Text('Envoi de la Bonne Action')),
      //key: _scaffoldKey,
      body: new Builder(
          builder: (BuildContext context){
            _scaffoldContext = context;
            return body;
          })
    );
  }

}


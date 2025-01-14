import 'dart:io';
import 'dart:async';

//Send image to server
import 'dart:convert';
import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/model/design.dart';
import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

//Design library
import 'package:flutter/material.dart';


class PhotoPage extends StatefulWidget {
  final ActionDB action;

  const PhotoPage({
    Key key,
    @required this.action
  }) : super(key: key);

  @override
  PhotoPageState createState() => PhotoPageState();
}

class PhotoPageState extends State<PhotoPage> {
  List<CameraDescription> _cameras;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<bool> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _initCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return ScaffoldDesign(
                title: "Prendre une photo",
                body: CameraPreview(_controller),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () async {
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
                      if (result == true) {
                        UserDB.addPoints(widget.action.nbPoints);
                        Navigator.pop(context, true);
                      }
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
                  String phpEndPoint = 'https://minecraft.yoannchappaz.best/receiveImage.php';
                  String base64Image = base64Encode(file.readAsBytesSync());
                  String fileName = file.path.split("/").last;

                  //Sending picture to server
                  http.Response res = await http.post(phpEndPoint, body: {
                    "image": base64Image,
                    "name": fileName,
                  }).catchError((e){Scaffold.of(_scaffoldContext).showSnackBar(
                      SnackBar(content: Text('Une erreur est survenue lors de l\'envoi...\nRéessayez à nouveau\nCode erreur : ' + e)));
                  });

                  //Check result
                  //If OK, adding points to user and return of the previous screen
                  //If not, display a error message
                  if (res.statusCode == 200)
                    Navigator.pop(context, true);
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


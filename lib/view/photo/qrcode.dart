import 'package:ba_locale/model/database/action.dart';
import 'package:ba_locale/model/design.dart';
import 'package:flutter/material.dart';

class QrcodePage extends StatefulWidget {
  final ActionDB action;

  const QrcodePage({
    Key key,
    @required this.action
  }) : super(key: key);

  @override
  _QrcodePageState createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return ScaffoldDesign(
      title: "Scanner un QRCode",
      body: Column(
        children: <Widget>[
          new Container(
            child: new MaterialButton(
                onPressed: (){}, child: new Text("Scan")),
            padding: const EdgeInsets.all(8.0),
          ),
          new Text(barcode),
        ],
      ));
  }

//  Future scan() async {
//    try {
//      String barcode = await BarcodeScanner.scan();
//      setState(() => this.barcode = barcode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        setState(() {
//          this.barcode = 'The user did not grant the camera permission!';
//        });
//      } else {
//        setState(() => this.barcode = 'Unknown error: $e');
//      }
//    } on FormatException {
//      setState(() =>
//      this.barcode =
//      'null (User returned using the "back"-button before scanning anything. Result)');
//    } catch (e) {
//      setState(() => this.barcode = 'Unknown error: $e');
//    }
//  }
}
//    return Scaffold(
//      appBar: new AppBar(
//        title: const Text('QRCode Reader Example'),
//      ),
//      body: new Center(
//          child: new FutureBuilder<String>(
//              future: _barcodeString,
//              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                return new Text(snapshot.data != null ? snapshot.data : '');
//              })),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: () {
//          setState(() {
//            _barcodeString = new QRCodeReader()
//                .setAutoFocusIntervalInMs(200)
//                .setForceAutoFocus(true)
//                .setTorchEnabled(true)
//                .setHandlePermissions(true)
//                .setExecuteAfterPermissionGranted(true)
//                .scan();
//          });
//        },
//        tooltip: 'Reader the QRCode',
//        child: new Icon(Icons.add_a_photo),
//      ),
//    );
//  }
//
//  Future scan() async {
//    try {
//      String barcode = await BarcodeScanner.scan();
//      setState(() => this.barcode = barcode);
//    } on PlatformException catch (e) {
//      if (e.code == BarcodeScanner.CameraAccessDenied) {
//        setState(() {
//          this.barcode = 'The user did not grant the camera permission!';
//        });
//      } else {
//        setState(() => this.barcode = 'Unknown error: $e');
//      }
//    } on FormatException{
//      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
//    } catch (e) {
//      setState(() => this.barcode = 'Unknown error: $e');
//    }
//  }
//}
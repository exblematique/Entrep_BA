import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//Drawer views
import 'package:ba_locale/view/drawer/presentaion.dart';
import 'package:ba_locale/view/drawer/maps.dart';
import 'package:ba_locale/view/drawer/manual.dart';
import 'package:ba_locale/view/drawer/help.dart';

//Bottom bar views
import 'package:ba_locale/view/bottomBar/home.dart';
import 'package:ba_locale/view/bottomBar/action.dart';
import 'package:ba_locale/view/bottomBar/photo.dart';
import 'package:ba_locale/view/bottomBar/notification.dart';
import 'package:ba_locale/view/bottomBar/profile.dart';


// The following code must be include in all children views
class AppPage extends StatefulWidget {
  final CameraDescription camera;
  const AppPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Constant design for all pages of the program
class AppState extends State<AppPage> {
  int _currentIndex = 0;
  static const Color _bgColor = Colors.blue;
  static CameraDescription _camera;

  final List<Widget> _bottomViews = [
    HomePage(),
    ActionPage(),
    PhotoPage(camera: _camera),
    NotificationPage(),
    ProfilePage(),
  ];

  final List<String> _bottomTitle = [
    'Page d\'acceuil',
    'Actions',
    'Prendre une photo',
    'Notification',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    //To send CameraDescription object in PhotoPage
    _camera = widget.camera;
    return Scaffold(
      appBar: AppBar(
        title: Text(_bottomTitle[_currentIndex]),
        //backgroundColor: _bgColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () { Scaffold.of(context).openDrawer(); },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: _bgColor,
              ),
              child: Text(
                'La BA locale',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Qui sommes nous ?'),
              onTap: () {
                Navigator.pushNamed(context, '/app/presentation');
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Trouver un commerçant'),
              onTap: () {
                Navigator.pushNamed(context, '/app/maps');
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Guide d\'utilisation'),
              onTap: () {
                Navigator.pushNamed(context, '/app/manual');
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Centre d\'aide'),
              onTap: () {
                Navigator.pushNamed(context, '/app/help');
              },
            ),
          ],
        ),
      ),
      body: _bottomViews[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Page d\'acceuil'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.directions_run),
            title: new Text('Actions'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.photo_camera),
            title: new Text('Photo')
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: new Text('Notifications')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profil')
          )
        ]
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
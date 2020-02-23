import 'package:ba_locale/model/database/user.dart';
import 'package:ba_locale/model/design.dart';
import 'package:ba_locale/view/login.dart';
import 'package:flutter/material.dart';

//Bottom bar views
import 'package:ba_locale/view/bottomBar/home.dart';
import 'package:ba_locale/view/bottomBar/action.dart';
import 'package:ba_locale/view/bottomBar/reduction.dart';
import 'package:ba_locale/view/bottomBar/maps.dart';
import 'package:ba_locale/view/bottomBar/profile.dart';



// The following code must be include in all children views
class AppPage extends StatefulWidget {
  const AppPage({
    Key key,
  }) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Constant design for all pages of the program
class AppState extends State<AppPage> {
  int _currentIndex = 0;

  static Widget body;

  static List<Widget> _bottomViews = [
    HomePage(),
    ActionPage(),
    ReductionPage(),
    MapsPage(),
    ProfilePage(),
  ];

  final List<String> _bottomTitle = [
    'Page d\'acceuil',
    'Actions',
    'Reductions',
    'Partenaires',
    'Profil',
  ];

  @override
  void initState(){
    body = HomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          color: ThemeDesign.backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: ThemeDesign.interfaceColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Text>[
                    TextInterfaceDesign('La Bonne Action Locale', size: 24),
                    TextInterfaceDesign("Votre nombre de points est : " + UserDB.nbPoints.toString()),
                  ]
              )),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Qui sommes nous ?'),
                onTap: () {
                  //setState(() => body = HelpPage());
                  Navigator.pushNamed(context, '/app/presentation');
                },
              ),
              ListTile(
                leading: Icon(Icons.library_books),
                title: Text('Guide d\'utilisation'),
                onTap: () {
                  //setState(() => body = Manual());

                  Navigator.pushNamed(context, '/app/manual');
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Centre d\'aide'),
                onTap: () {
                  //setState(() => body = HelpPage());

                  Navigator.pushNamed(context, '/app/help');
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Se déconnecter'),
                onTap: () {
                  UserDB.signOut()
                      .then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginApp())));
                },
              ),
            ],
          ),
        )
      ),
      body: body,

      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        //fixedColor: ThemeDesign.interfaceColor,
        //backgroundColor: ThemeDesign.interfaceColor,
        selectedItemColor: ThemeDesign.mainTxtColor,
        unselectedItemColor: ThemeDesign.secTxtColor,
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
            icon: new Icon(Icons.euro_symbol),
            title: new Text('Réductions'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Partenaire'),
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
      body = _bottomViews[index];
      _currentIndex = index;
    });
  }
}

//class ListTileDesign extends ListTile {
//
//  ListTileDesign({@required key, @required String title, @required IconData icon, @required StatefulWidget redirect})
//    : super (
//      leading: new Icon(icon),
//      title: Text(title),
//      onTap: () => setState(() => body = Manual());
//  );
//}
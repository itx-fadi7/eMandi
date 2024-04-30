import 'package:emandi/about.dart';
import 'package:emandi/main.dart';
import 'package:emandi/polices.dart';
import 'package:emandi/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => SplashScreen(),
    ),
  );
}

class navBar extends StatefulWidget {
  final String email;
  navBar({Key? key, required this.email}) : super(key: key);

  @override
  State<navBar> createState() => _NavBarState();
}

class _NavBarState extends State<navBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.email);
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Fahad Ali'),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/fadi.png')),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/img_4.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            email: widget.email,
                          )));
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text('About'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => about()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
            onTap: () => null,
            trailing: Container(
              color: Colors.red,
              width: 20,
              height: 20,
              child: Center(child: Text('8')),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => polices()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Exit'),
            onTap: () {
              logout(context);
            },
          )
        ],
      ),
    );
  }
}

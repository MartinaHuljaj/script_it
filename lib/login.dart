import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User? user;
  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UploadPage()))
        });
  }

  Widget googleloginButton() {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/pozadina3.png"),
              fit: BoxFit.cover,
              opacity: 0.9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: this.click,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)),
                shadowColor: Colors.grey,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey),
              ),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image(
                          image: AssetImage('assets/google_logo.png'),
                          height: 35),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('Sign in with Google',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 20,
                                  fontFamily: 'Anton')))
                    ],
                  )),
            )
          ],
        ));
  }

  Widget loginPage() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/pozadina.png"), fit: BoxFit.cover),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Text('nekitext')),
        ),
        googleloginButton()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleloginButton());
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'clipper.dart';
import 'custom/customTextFile.dart';

import 'Dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Register());
}
class Register extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginRegister(),
    );
  }

}

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  String _email;
  String _password;
  String _displayName;
  bool _loading = false;
  bool _autoValidate = false;
  String errorMsg = "";

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    //GO logo widget

    //button widgets
    Widget filledButton(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, Future<String> function()) {
      return RaisedButton(
        highlightElevation: 0.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 0.0,
        color: fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {

          function().then((result){
            if (result!=null)
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Dashboard();
                  },
                ),
              );
            }
          }

          );
          ;



        },
      );
    }

    outlineButton(Future <String> function()) {
      return OutlineButton(
        highlightedBorderColor: Colors.white,
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        highlightElevation: 0.0,
        splashColor: Colors.white,
        highlightColor: Theme.of(context).primaryColor,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: Text(
          "REGISTER",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          function().then((result){
            if (result!=null)
            {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Dashboard();
                  },
                ),
              );
            }
          }

          );

        },
      );
    }

      Future <String> _validateLoginInput() async {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final FormState form = _formKey.currentState;
        if (_formKey.currentState.validate()) {
          form.save();
          _sheetController.setState(() {
            _loading = true;
          });

          try{
            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _email,
                password: _password,
            );
            final User user = userCredential.user;
            if (user != null)
            {

              final User currentUser = _auth.currentUser;
              assert(user.uid == currentUser.uid);

              print('signInWithGoogle succeeded: $user');


              return '$user';
            }
            return null;

          }
          catch(error){

          }

        }
        else {
          setState(() {
            _autoValidate = true;
          });
        }



      }

    Future <String> _validateRegisterInput() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;


        });
        try {
          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password

          );

          final User user = userCredential.user;
          if (user != null)
            {

              final User currentUser = _auth.currentUser;
              assert(user.uid == currentUser.uid);
              final firestoreInstance = FirebaseFirestore.instance;

              var firebaseUser =  FirebaseAuth.instance.currentUser;
              firestoreInstance.collection("users").doc(firebaseUser.uid).set(
                  {
                    "email" : _email,


                  }).then((_){
                print("success!");
              });

              print('signInWithGoogle succeeded: $user');

              return '$user';
            }
          return null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }

      } else {
        setState(() {
          _autoValidate = true;
        });
      }


    }

    String emailValidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.isEmpty) return '*Required';
      if (!regex.hasMatch(value))
        return '*Enter a valid email';
      else
        return null;
    }

   Future<String> loginSheet()  async{
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Align(
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).primaryColor),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20, top: 60),
                                child: CustomTextField(
                                  onSaved: (input) {
                                    _email = input;
                                  },
                                  validator: emailValidator,
                                  icon: Icon(Icons.email),
                                  hint: "EMAIL",
                                )),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: CustomTextField(
                                  icon: Icon(Icons.lock),
                                  obsecure: true,
                                  onSaved: (input) => _password = input,
                                  validator: (input) =>
                                  input.isEmpty ? "*Required" : null,
                                  hint: "PASSWORD",
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: _loading == true
                                  ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryColor),
                              )
                                  : Container(

                                child: filledButton(
                                  "LOGIN",
                                  Colors.white,
                                  primaryColor,
                                  primaryColor,
                                  Colors.white,
                                  _validateLoginInput),

                                height: 50,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    Future<String> registerSheet() async {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        child: Column(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Align(
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 25, right: 40),
                                    child: Text(
                                      "REGI",
                                      style: TextStyle(
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Positioned(
                                  child: Align(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 40, left: 28),
                                      width: 130,
                                      child: Text(
                                        "STER",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                                top: 60,
                              ),
                              child: CustomTextField(
                                icon: Icon(Icons.account_circle),
                                hint: "DISPLAY NAME",
                                validator: (input) =>
                                input.isEmpty ? "*Required" : null,
                                onSaved: (input) => _displayName = input,
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: CustomTextField(
                                icon: Icon(Icons.email),
                                hint: "EMAIL",
                                onSaved: (input) {
                                  _email = input;
                                },
                                validator: emailValidator,
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: CustomTextField(
                                icon: Icon(Icons.lock),
                                obsecure: true,
                                onSaved: (input) => _password = input,
                                validator: (input) =>
                                input.isEmpty ? "*Required" : null,
                                hint: "PASSWORD",
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: _loading
                                ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primaryColor),
                            )
                                : Container(
                              child: filledButton(
                                  "REGISTER",
                                  Colors.white,
                                  primaryColor,
                                  primaryColor,
                                  Colors.white,
                                  _validateRegisterInput),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                        key: _formKey,
                        autovalidate: _autoValidate,
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[

            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Padding(
              child: Container(
                child: filledButton("LOGIN", primaryColor, Colors.white,
                    Colors.white, primaryColor, loginSheet ),
                height: 50,
              ),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: 20,
                  right: 20),
            ),
            Padding(
              child: Container(
                child: outlineButton(registerSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }
}

class FirestoreService {


}
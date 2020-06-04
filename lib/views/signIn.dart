import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/helper/helperFunction.dart';
import 'package:jchatapp/services/auth.dart';
import 'package:jchatapp/services/database.dart';
import 'package:jchatapp/widgets/widget.dart';

import 'chatScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();

  AuthenticationMethod authenticationMethod = new AuthenticationMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailte = new TextEditingController();
  TextEditingController passwordte = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunction.savedEmail(emailte.text);

      databaseMethods.getUserByEmail(emailte.text).then(
        (val) {
          snapshotUserInfo = val;
          HelperFunction.savedUserName(
            snapshotUserInfo.documents[0].data["name"],
          );
        },
      );
      setState(() {
        isLoading = true;
      });

      authenticationMethod
          .signInWithEmailAndPassword(emailte.text, passwordte.text)
          .then((val) {
        if (val != null) {
          databaseMethods.getUserByEmail(emailte.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Chatroom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val) {
                        return RegExp(r"^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$")
                                .hasMatch(val)
                            ? null
                            : "Please Provide A Valid E-Mail ID";
                      },
                      controller: emailte,
                      style: simpleTextInput(),
                      decoration: textFieldInputDecoration("Email"),
                    ),
                    TextFormField(
                      validator: (val) {
                        return val.length > 6
                            ? null
                            : "The Password Should Be More Than 6 Characters";
                      },
                      controller: passwordte,
                      obscureText: true,
                      style: simpleTextInput(),
                      decoration: textFieldInputDecoration("Password"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 13,
              ),
             /* Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Forgot Password?",
                    style: simpleTextInput(),
                  ),
                ),
              ), */
              SizedBox(
                height: 13,
              ),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  "Sign In With Google",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),*/
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't Have An Account?",
                    style: simpleTextInput(),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Register Now",
                        style: TextStyle(color: Colors.purple, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

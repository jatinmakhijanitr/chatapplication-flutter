import 'package:flutter/material.dart';
import 'package:jchatapp/helper/helperFunction.dart';
import 'package:jchatapp/services/auth.dart';
import 'package:jchatapp/views/chatScreen.dart';
import 'package:jchatapp/widgets/widget.dart';
import 'package:jchatapp/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthenticationMethod authenticationMethod = new AuthenticationMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController usernamete = new TextEditingController();
  TextEditingController emailte = new TextEditingController();
  TextEditingController passwordte = new TextEditingController();

  signMeUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authenticationMethod
          .signUpWithEmailAndPassword(emailte.text, passwordte.text)
          .then((val) {
        Map<String, String> userInfoMap = {
          "name": usernamete.text,
          "email": emailte.text,
        };

        HelperFunction.savedEmail(emailte.text);
        HelperFunction.savedUserName(usernamete.text);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.savedUserLogin(true);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Chatroom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
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
                              return val.isEmpty || val.length < 4
                                  ? "Please Provide a Username"
                                  : null;
                            },
                            controller: usernamete,
                            style: simpleTextInput(),
                            decoration: textFieldInputDecoration("Username"),
                          ),
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
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "The Password Should Be More Than 6 Characters";
                            },
                            controller: passwordte,
                            style: simpleTextInput(),
                            decoration: textFieldInputDecoration("Password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
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
                          "Sign Up",
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
                        "Sign Up With Google",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),*/
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already Have An Account?",
                            style: simpleTextInput()),
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
                              "Sign In Now",
                              style:
                                  TextStyle(color: Colors.purple, fontSize: 16),
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

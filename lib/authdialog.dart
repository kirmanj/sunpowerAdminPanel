import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/homeScreen.dart';
import 'package:explore/main.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/web/responsive%20copy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthDialog extends StatefulWidget {
  @override
  _AuthDialogState createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;
  bool _isRegistering = false;
  bool _isLoggingIn = false;

  late TextEditingController textControllerName;
  late TextEditingController textControllerAddress;

  String? loginStatus;
  Color loginStringColor = Colors.green;

  late TextEditingController textControllerPhone;

  bool _isEditingPhone = false;
  bool _isEditingName = false;
  bool _isEditingAddress = false;

  late TextEditingController otp;
  String? _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return null;
  }

  String? _validateName(String value) {
    value = value.trim();

    if (textControllerName.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Username can\'t be empty';
      }
    }

    return null;
  }

  String? _validateAddress(String value) {
    value = value.trim();

    if (textControllerAddress.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Address can\'t be empty';
      }
    }

    return null;
  }

  String? _validatePassword(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of password should be greater than 6';
      }
    }

    return null;
  }

  bool adminEmail = false;

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerPhone = TextEditingController();
    textControllerAddress = TextEditingController();
    textControllerName = TextEditingController();
    textControllerEmail.text = '';
    textControllerPassword.text = '';
    textControllerAddress.text = '';
    textControllerName.text = '';
    textFocusNodeEmail = FocusNode();

    textFocusNodePassword = FocusNode();
    super.initState();
  }

  bool isNew = false;

  late UserCredential userCredential;

  var temp;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(16.0),
          color: Theme.of(context).backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset('assets/images/sunpower.png'),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.subtitle2!.color,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                ),
                child: TextField(
                  focusNode: textFocusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerEmail,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      _isEditingEmail = true;
                    });
                    if (textControllerEmail.text.contains(".com")) {
                      FirebaseFirestore.instance
                          .collection("Admin")
                          .doc("adminUser")
                          .get()
                          .then((value) {
                        String email = value.get("email");
                        if (email == textControllerEmail.text.toString()) {
                          setState(() {
                            adminEmail = true;
                          });
                        }
                      });
                    } else {
                      setState(() {
                        adminEmail = false;
                      });
                    }
                  },
                  onSubmitted: (value) {
                    textFocusNodeEmail.unfocus();
                    FocusScope.of(context).requestFocus(textFocusNodePassword);
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[800]!,
                        width: 3,
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                      color: Colors.blueGrey[300],
                    ),
                    hintText: "Email",
                    fillColor: Colors.white,
                    errorText: _isEditingEmail
                        ? _validateEmail(textControllerEmail.text)
                        : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              !adminEmail
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        bottom: 8,
                      ),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.subtitle2!.color,
                            fontSize: 18),
                      ),
                    ),
              !adminEmail
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20,
                      ),
                      child: TextField(
                        focusNode: textFocusNodePassword,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: textControllerPassword,
                        obscureText: true,
                        autofocus: false,
                        onChanged: (value) {
                          setState(() {
                            _isEditingPassword = true;
                          });
                        },
                        onSubmitted: (value) {
                          textFocusNodePassword.unfocus();
                          FocusScope.of(context)
                              .requestFocus(textFocusNodePassword);
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blueGrey[800]!,
                              width: 3,
                            ),
                          ),
                          filled: true,
                          hintStyle: new TextStyle(
                            color: Colors.blueGrey[300],
                          ),
                          hintText: "Password",
                          fillColor: Colors.white,
                          errorText: _isEditingPassword
                              ? _validatePassword(textControllerPassword.text)
                              : null,
                          errorStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: isNew
                          ? SizedBox.shrink()
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  _isLoggingIn = true;
                                  textFocusNodeEmail.unfocus();
                                  textFocusNodePassword.unfocus();
                                });
                                if (_validateEmail(textControllerEmail.text) ==
                                        null &&
                                    _validatePassword(
                                            textControllerPassword.text) ==
                                        null) {
                                  await signInWithEmailPassword(
                                          textControllerEmail.text,
                                          textControllerPassword.text,
                                          context)
                                      .then((result) {
                                    setState(() {
                                      loginStatus =
                                          'You have successfully logged in';
                                      loginStringColor = Colors.green;
                                    });
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => HomeScreen(),
                                      ));
                                    });
                                  }).catchError((error) {
                                    print('Login Error: $error');
                                    setState(() {
                                      loginStatus =
                                          'Error occured while logging in';
                                      loginStringColor = Colors.red;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    loginStatus =
                                        'Please enter email & password';
                                    loginStringColor = Colors.red;
                                  });
                                }
                                setState(() {
                                  _isLoggingIn = false;
                                  textControllerEmail.text = '';
                                  textControllerPassword.text = '';
                                  _isEditingEmail = false;
                                  _isEditingPassword = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color.fromARGB(254, 246, 238, 50),
                                      Color.fromARGB(254, 211, 160, 38),
                                      Color.fromARGB(254, 246, 238, 50),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0,
                                  ),
                                  child: _isLoggingIn
                                      ? SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: 50.0,
                                              right: 50.0,
                                              bottom: 1.0,
                                              top: 1.0),
                                          child: Text(
                                            "login",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              loginStatus != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        child: Text(
                          loginStatus!,
                          style: TextStyle(
                            color: loginStringColor,
                            fontSize: 14,
                            // letterSpacing: 3,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 40.0,
                  right: 40.0,
                ),
                child: Container(
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.blueGrey[200],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Sunpower',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle2!.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          // letterSpacing: 3,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Text(
                            'Admin Check ',
                            //maxLines: 2,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle2!.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              // letterSpacing: 3,
                            ),
                          ),
                          Icon(
                            !adminEmail ? Icons.cancel : Icons.check_circle,
                            color: adminEmail ? Colors.green : Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

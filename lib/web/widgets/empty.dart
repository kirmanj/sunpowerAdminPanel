import 'dart:async';
import 'package:flutter/material.dart';

class EmptyWidget extends StatefulWidget {

  @override
  _EmptyWidgetState createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          loading
              ? Column(
            children: [
              SizedBox(
                height: screenHeight / 3,
              ),
              Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  )),
            ],
          )
              : Column(
            children: [
              SizedBox(
                height: screenHeight / 3,
              ),
              Center(
                child: Text(
                  "Empty",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

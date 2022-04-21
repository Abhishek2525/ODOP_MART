import 'package:flutter/material.dart';

/// This [Widget] designed for showing a custom progress dialog for
/// any FFuturistic workd like getting data from server or
/// any kinda [Future] operation in application to make user experience better
class ProgressDialog extends StatelessWidget {
  final String message;
  ProgressDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.black.withAlpha(200),
      child: Center(
        child: new Container(
          padding: const EdgeInsets.all(30.0),
          child: new GestureDetector(
            onTap: () {},
            child: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new SizedBox(height: 15.0),
                  new Text(
                    message ?? "Please wait....",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

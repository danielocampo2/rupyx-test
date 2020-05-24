import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {

  const FullWidthButton({this.text, this.onPressed});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(12),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
        disabledColor: Color(0xFFE4E3E9),
        disabledTextColor: Color(0xFFCDCCD4),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        child: Text(text),
      ),
    );
  }

}
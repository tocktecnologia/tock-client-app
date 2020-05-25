import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_setup_cognito/shared/utils/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

class InputLogin extends StatefulWidget {
  InputLogin({
    this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.textEditingController,
    this.validator,
    this.focusNode,
  });
  final focusNode;
  final validator;
  final prefixIcon;
  final hint;
  final keyboardType;
  final textEditingController;
  final obscureText;

  @override
  _InputLoginState createState() => _InputLoginState();
}

class _InputLoginState extends State<InputLogin> {
  bool showPassword = false;

  String _validator(value) {
    if (widget.obscureText) {
      if (value == null || value.isEmpty) {
        return 'type a ${widget.hint}';
      }
      return null;
    } else {
      if (value == null || value.isEmpty) {
        return 'type a ${widget.hint}';
      }
      return null;
    }
  }

  handleShowPass() {
    return IconButton(
      icon: showPassword
          ? Icon(Icons.remove_red_eye, color: Colors.white, size: 20)
          : Icon(Icons.visibility_off, color: Colors.white, size: 20),
      color: ColorsCustom.loginScreenDown,
      onPressed: () {
        setState(() => showPassword = !showPassword);
      },
    );
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: DecorationsLogin.borderInput,
      height: (size.height) * 0.066,
      // /width: (size.width) * 0.74,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(widget.prefixIcon, color: Colors.white),
            Expanded(
              child: TextFormField(
                focusNode: widget.focusNode,
                validator: widget.validator ?? _validator,
                controller: widget.textEditingController,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  errorStyle: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black38,
                    height: -1,
                  ),
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.white38),
                  // labelText: widget.hint,
                  // labelStyle: TextStyle(fontSize: 15.0, color: Colors.white54),
                ),
                obscureText: widget.obscureText ? !showPassword : false,
                keyboardType: widget.keyboardType,
              ),
            ),
            widget.obscureText ? handleShowPass() : Container(),
          ],
        ),
      ),
    );
  }
}

class ButtonLogin extends MaterialButton {
  ButtonLogin(
      {this.backgroundColor = Colors.transparent,
      this.borderColor = ColorsCustom.loginScreenMiddle,
      this.label = 'OK',
      this.labelColor = ColorsCustom.loginScreenUp,
      this.mOnPressed,
      this.isLoading = false,
      this.height,
      this.minWidth,
      this.fontSize});
  final minWidth;
  final height;
  final bool isLoading;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color labelColor;
  final VoidCallback mOnPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ButtonTheme(
      minWidth: minWidth ?? size.width * 0.316,
      height: height ?? size.height * 0.053,
      child: RaisedButton(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: this.borderColor)),
        color: backgroundColor,
        child: isLoading
            ? FittedBox(
                fit: BoxFit.cover,
                child: Row(
                  children: <Widget>[
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: labelColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SpinKitThreeBounce(
                      size: 20,
                      color: ColorsCustom.loginScreenUp,
                    ),
                  ],
                ),
              )
            : Text(
                label,
                style: TextStyle(
                    fontSize: fontSize ?? 20.0,
                    color: labelColor,
                    fontWeight: FontWeight.bold),
              ),
        onPressed: mOnPressed,
      ),
    );
  }
}

class ShowProgress {
  static open({@required context, titleText, @required contentText}) {
    showDialog(
        context: context,
        child: Alert(
          titleText: titleText == null ? 'Alert' : titleText,
          contentText: contentText,
        ));
  }
}

class ProgressAlert extends AlertDialog {
  final String titleText;
  final Widget contentText;

  ProgressAlert({this.titleText, this.contentText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 5,
      title: titleText != null
          ? Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsCustom.loginScreenUp),
            )
          : Icon(
              Icons.info_outline,
              size: 60,
              color: ColorsCustom.loginScreenUp,
            ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[contentText],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: ColorsCustom.loginScreenMiddle),
          ),
          color: ColorsCustom.loginScreenUp,
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    );
  }
}

class ShowAlert {
  static open({@required context, titleText, @required contentText}) {
    showDialog(
        context: context,
        child: Alert(
          titleText: titleText == null ? 'Alert' : titleText,
          contentText: contentText,
        ));
  }
}

class Alert extends AlertDialog {
  final String titleText;
  final String contentText;

  Alert({this.titleText, this.contentText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 5,
      title: titleText != null
          ? Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsCustom.loginScreenUp),
            )
          : Icon(
              Icons.info_outline,
              size: 60,
              color: ColorsCustom.loginScreenUp,
            ),
      content: SingleChildScrollView(
        child: Text(
          contentText,
          style: TextStyle(color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: ColorsCustom.loginScreenMiddle),
          ),
          color: ColorsCustom.loginScreenUp,
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        )
      ],
    );
  }
}

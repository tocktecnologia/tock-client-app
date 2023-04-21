import 'package:flutter/material.dart';
import 'package:client/shared/utils/styles.dart';
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
      return "";
    } else {
      if (value == null || value.isEmpty) {
        return 'type a ${widget.hint}';
      }
      return "";
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
  const ButtonLogin(
      {super.key,
      this.backgroundColor = Colors.transparent,
      this.borderColor = ColorsCustom.loginScreenMiddle,
      this.label = 'OK',
      this.labelColor = ColorsCustom.loginScreenDown,
      required this.mOnPressed,
      this.isLoading = false,
      // this.height,
      // this.minWidth,
      this.fontSize})
      : super(onPressed: mOnPressed);
  // final double? minWidth;
  // final double? height;
  final bool isLoading;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color labelColor;
  final VoidCallback mOnPressed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: RaisedButton(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: borderColor),
        ),
        onPressed: mOnPressed,
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
                    const SpinKitThreeBounce(
                      size: 20,
                      color: ColorsCustom.loginScreenDown,
                    ),
                  ],
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: fontSize ?? 20.0,
                  // color: labelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class ShowAlert {
  static open(
      {@required context,
      titleText,
      @required contentText,
      confirmationText,
      onConfirmation}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            : const Icon(
                Icons.info_outline,
                size: 60,
                color: ColorsCustom.loginScreenUp,
              ),
        content: SingleChildScrollView(
          child: Text(
            contentText,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: ColorsCustom.loginScreenMiddle),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (onConfirmation != null) onConfirmation();
            },
            child: Text(confirmationText ?? 'OK'),
          )
        ],
      ),
    );
  }
}

class ShowAlertOptions {
  static open(
      {required context,
      titleText,
      required contentText,
      required VoidCallback action}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            : const Icon(
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Não'),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: ColorsCustom.loginScreenMiddle),
            ),
            onPressed: () {
              action();
              // Navigator.pop(context);
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }
}

class RaisedButton extends ElevatedButton {
  final RoundedRectangleBorder? shape;
  final double? elevation;

  const RaisedButton({
    super.key,
    this.elevation,
    this.shape,
    required super.onPressed,
    required super.child,
  });

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(elevation ?? 1),
        shape: MaterialStateProperty.all(
          shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
        ),
      ),
      child: child,
    );
  }
}

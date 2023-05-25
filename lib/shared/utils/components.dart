import 'dart:async';

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

// This is the actual package file, this is here to use the interactive example with dartpad correctly
class InkWellSplash extends StatelessWidget {
  InkWellSplash({
    Key? key,
    this.child,
    this.onTap,
    this.onDoubleTap,
    this.doubleTapTime = const Duration(milliseconds: 300),
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.onHighlightChanged,
    this.onHover,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.splashFactory,
    this.radius,
    this.borderRadius,
    this.customBorder,
    this.enableFeedback = true,
    this.excludeFromSemantics = false,
    this.focusNode,
    this.canRequestFocus = true,
    this.onFocusChange,
    this.autofocus = false,
  })  : assert(enableFeedback != null),
        assert(excludeFromSemantics != null),
        assert(autofocus != null),
        assert(canRequestFocus != null),
        super(key: key);

  final Widget? child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final Duration doubleTapTime;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final ValueChanged<bool>? onHighlightChanged;
  final ValueChanged<bool>? onHover;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? radius;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;
  final bool? enableFeedback;
  final bool? excludeFromSemantics;
  final FocusNode? focusNode;
  final bool? canRequestFocus;
  final ValueChanged<bool>? onFocusChange;
  final bool? autofocus;

  Timer? doubleTapTimer;
  bool isPressed = false;
  bool isSingleTap = false;
  bool isDoubleTap = false;

  void _doubleTapTimerElapsed() {
    if (isPressed) {
      isSingleTap = true;
    } else {
      if (onTap != null) onTap!();
    }
  }

  void _onTap() {
    isPressed = false;
    if (isSingleTap) {
      isSingleTap = false;
      if (onTap != null) onTap!(); // call user onTap function
    }
    if (isDoubleTap) {
      isDoubleTap = false;
      if (onDoubleTap != null) onDoubleTap!();
    }
  }

  void _onTapDown(TapDownDetails details) {
    isPressed = true;
    if (doubleTapTimer != null && doubleTapTimer!.isActive) {
      isDoubleTap = true;
      doubleTapTimer?.cancel();
    } else {
      doubleTapTimer = Timer(doubleTapTime, _doubleTapTimerElapsed);
    }
    if (onTapDown != null) onTapDown!(details);
  }

  void _onTapCancel() {
    isPressed = isSingleTap = isDoubleTap = false;
    doubleTapTimer?.cancel();
    if (onTapCancel != null) onTapCancel!();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      onTap: (onDoubleTap != null)
          ? _onTap
          : onTap, // if onDoubleTap is not used from user, then route further to onTap
      onLongPress: onLongPress,
      onTapDown: (onDoubleTap != null) ? _onTapDown : onTapDown,
      onTapCancel: (onDoubleTap != null) ? _onTapCancel : onTapCancel,
      onHighlightChanged: onHighlightChanged,
      onHover: onHover,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback,
      excludeFromSemantics: excludeFromSemantics!,
      focusNode: focusNode,
      canRequestFocus: canRequestFocus!,
      onFocusChange: onFocusChange,
      autofocus: autofocus!,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_state.dart';
import 'package:flutter_login_setup_cognito/screens/login/signUp/confirmation_signUp.dart';
import 'package:flutter_login_setup_cognito/shared/colors.dart';
import 'package:flutter_login_setup_cognito/shared/components.dart';
import 'package:flutter_login_setup_cognito/shared/screen_transitions/slide.transition.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  String _validatorEmail(value) {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");
    if (!regExp.hasMatch(value)) {
      return "type a valid email";
    }
    return null;
  }

  _signUp() {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<BlocAuth>(context).add(
        SignUpEvent(
          login: emailController.text,
          password: passController.text,
          // if you want more attributes, just do add in json
          jsonAttrs: {'email': emailController.text},
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.loginScreenMiddle,
      appBar: new AppBar(
        title: new Text('SignUp'),
        backgroundColor: ColorsCustom.loginScreenMiddle,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputLogin(
                validator: _validatorEmail,
                prefixIcon: Icons.account_circle,
                hint: 'email',
                keyboardType: TextInputType.emailAddress,
                textEditingController: emailController,
              ),
              SizedBox(height: 30.0),
              InputLogin(
                prefixIcon: Icons.lock,
                hint: 'senha',
                obscureText: true,
                textEditingController: passController,
              ),
              SizedBox(height: 30.0),
              _buttonSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSignUp() {
    return BlocBuilder<BlocAuth, AuthState>(
      condition: (previusState, state) {
        if (state is LoadedSignUpState) {
          Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: ConfirmSignUpScreen(
                  email: emailController.text,
                ),
              ));
        } else if (state is LoginErrorState) {
          ShowAlert.open(context: context, contentText: state.message);
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingSignUpState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'loading ...',
            mOnPressed: () => {},
          );
        } else if (state is LoadedSignUpState) {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Success!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'OK',
            mOnPressed: () => _signUp(),
          );
        }
      },
    );
  }
}

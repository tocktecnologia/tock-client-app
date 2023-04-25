import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_state.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/screen_transitions/slide.transition.dart';
import 'package:client/shared/utils/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final numConfirmationController = TextEditingController();
  final newPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _forgotPassword() {
    if (_formKey.currentState!.validate()) {
      // BlocProvider.of<AuthBloc>(context).add(
      //   ForgotPasswordEvent(
      //       email: widget.email,
      //       newPassowrd: newPassController.text,
      //       confirmationCode: numConfirmationController.text),
      // );
    }
  }

  _resendCode() {
    // BlocProvider.of<AuthBloc>(context)
    //     .add(SendCodeForgotPasswordEvent(email: widget.email));
  }

  @override
  void dispose() {
    super.dispose();
    numConfirmationController.dispose();
    newPassController.dispose();
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<AuthBloc>(context)
    //     .add(SendCodeForgotPasswordEvent(email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.loginScreenMiddle,
      appBar: new AppBar(
        title: new Text('Change Password'),
        backgroundColor: ColorsCustom.loginScreenMiddle,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _textTitle(),
                SizedBox(height: 30.0),
                InputLogin(
                  prefixIcon: Icons.local_offer,
                  hint: 'Code',
                  keyboardType: TextInputType.number,
                  textEditingController: numConfirmationController,
                ),
                SizedBox(height: 30.0),
                InputLogin(
                  prefixIcon: Icons.lock,
                  hint: 'new password',
                  obscureText: true,
                  textEditingController: newPassController,
                ),
                SizedBox(height: 30.0),
                _buttonSignUp(),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () => _resendCode(),
                  child: Text(
                    'Resend Code',
                    textAlign: TextAlign.center,
                    style: TextStylesLogin.textLink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textTitle() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (previusState, state) {
        if (state is LoadingSendCodeState) {
          return ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              SizedBox(
                child: SpinKitWave(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Resend code for ${widget.email} ...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else
          return Text(
            "Verify the code sent to email ${widget.email}",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          );
      },
    );
  }

  Widget _buttonSignUp() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previusState, state) {
        if (state is LoadedForgotPasswordState) {
          Navigator.pushReplacement(
              context, SlideDownRoute(page: LoginScreen()));
        } else if (state is LoginErrorState) {
          ShowAlert.open(context: context, contentText: state.message);
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingForgotPasswordState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'Loading ...',
            mOnPressed: () => {},
          );
        } else if (state is LoadedForgotPasswordState) {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Success!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'OK',
            mOnPressed: () => _forgotPassword(),
          );
        }
      },
    );
  }
}

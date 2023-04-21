import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_event.dart';
import 'package:client/bloc/auth/auth_state.dart';
import 'package:client/screens/login/main.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/screen_transitions/slide.transition.dart';
import 'package:client/shared/utils/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConfirmSignUpScreen extends StatefulWidget {
  final email;

  const ConfirmSignUpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ConfirmSignUpScreenState createState() => _ConfirmSignUpScreenState();
}

class _ConfirmSignUpScreenState extends State<ConfirmSignUpScreen> {
  final numConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    numConfirmationController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.loginScreenUp,
      appBar: new AppBar(
        title: new Text('Coinfirm your SignUp'),
        backgroundColor: ColorsCustom.loginScreenUp,
      ),
      body: _form(),
    );
  }

  _form() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _textTitle(),
                SizedBox(height: 40.0),
                InputLogin(
                  prefixIcon: Icons.local_offer,
                  hint: 'Code',
                  keyboardType: TextInputType.number,
                  textEditingController: numConfirmationController,
                ),
                SizedBox(height: 30.0),
                _buttonSignUp(),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () => _resendConfirmationCode(),
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

  _confirmSignUp() {
    if (_formKey.currentState!.validate()) {
      // BlocProvider.of<AuthBloc>(context).add(
      //   ConfirmSignUpEvent(
      //       email: widget.email,
      //       confirmationCode: numConfirmationController.text),
      // );
    }
  }

  _resendConfirmationCode() {
    // BlocProvider.of<AuthBloc>(context)
    //     .add(SendCodeConfirmSignUpEvent(email: widget.email));
  }

  Widget _textTitle() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (previusState, state) {
        if (state is LoadingSendCodeConfirmSignUpState) {
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
        if (state is LoadedConfirmSignUpState) {
          Navigator.pushReplacement(
              context, SlideDownRoute(page: LoginScreen()));
        } else if (state is LoginErrorState) {
          ShowAlert.open(context: context, contentText: state.message);
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingConfirmSignUpState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'Loading ...',
            mOnPressed: () => {},
          );
        } else if (state is LoadedConfirmSignUpState) {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Success!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'OK',
            mOnPressed: () => _confirmSignUp(),
          );
        }
      },
    );
  }
}

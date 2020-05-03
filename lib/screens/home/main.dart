import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_state.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/fade.transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          actions: _iconsStatus(),
          title: Text('Olá'),
          centerTitle: true,
        ),
        backgroundColor: ColorsCustom.loginScreenMiddle,
        body: _content(),
      ),
    );
  }

  _iconsStatus() {
    final iconRemote = BlocProvider.of<BlocAuth>(context).isConnectedRemote
        ? Icon(Icons.cloud, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
    final iconLocal = BlocProvider.of<BlocAuth>(context).isConnectedLocal
        ? Icon(Icons.wifi_tethering, color: Colors.white)
        : Icon(Icons.portable_wifi_off, color: Colors.white30);

    return [iconLocal, SizedBox(width: 20), iconRemote, SizedBox(width: 10)];
  }

  _content() {
    return BlocBuilder<BlocAuth, AuthState>(condition: (previousState, state) {
      if (state is LoggedOutState) {
        Navigator.pushReplacement(context, FadeRoute(page: LoginScreen()));
      }
      return;
    }, builder: (context, state) {
      if (state is LoadingLogoutState) {
        return SizedBox(
          child: SpinKitWave(
            color: Colors.white,
          ),
        );
      } else {
        final email = Locator.instance.get<UserCognito>().userAttrs['email'];
        return Center(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 80),
              SizedBox(height: 40),
              InkWell(
                onTap: () =>
                    BlocProvider.of<BlocAuth>(context).add(LogoutEvent()),
                child: Text(
                  "teste $email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      decoration: TextDecoration.underline,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

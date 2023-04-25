import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/mqtt/mqtt_bloc.dart';
import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/services/cognito/user.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_state.dart';
import 'package:client/screens/home/main.dart';
import 'package:client/screens/login/signUp/confirmation_signUp.dart';
import 'package:client/screens/login/signUp/signUp.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/screen_transitions/open.transition.dart';
import 'package:client/shared/utils/screen_transitions/slide.transition.dart';
import 'package:client/shared/utils/styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'forgotPassword.dart';

class LoginScreen extends StatefulWidget {
  final String? login;
  const LoginScreen({this.login, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passController = TextEditingController();
  late Size size;
  final regExp = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");

  @override
  void initState() {
    super.initState();
    loginController.text = widget.login ?? 'izaiasemjr@gmail.com';
    passController.text = 'junymqwe';
  }

  @override
  void dispose() {
    super.dispose();
    loginController.dispose();
    passController.dispose();
    // Cognito.registerCallback(null);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorsCustom.loginScreenUp,
      body: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.0871),
          Image.asset(
            'assets/images/logo.png',
            height: 140,
            fit: BoxFit.fill,
          ),
          SizedBox(height: size.height * 0.020),
          Expanded(
            child: _contentLogin(),
          ),
        ],
      ),
    );
  }

  Widget _contentLogin() {
    return BlocBuilder<AuthCubit, AuthState>(buildWhen: (previousState, state) {
      if (state is LoggedState) {
        // BlocProvider.of<IotAwsBloc>(context).add(ConnectIotAwsEvent());
        context.read<DataUserCubit>().getDataUser();
        context.read<MqttCubit>().mqttConnect();
        Navigator.pushReplacement(
          context,
          OpenAndFadeTransition(
            const HomeScreen(),
          ),
        );
      } else if (state is LoginErrorState) {
        ShowAlert.open(
            context: context,
            titleText: "Alerta de Conexão",
            contentText: "${state.message}");
      }
      return true;
    }, builder: (context, state) {
      if (state is ForcingLoginState || state is LoggedState) {
        return const SizedBox(child: SpinKitWave(color: Colors.white));
      } else {
        return _formLogin();
      }
    });
  }

  Widget _formLogin() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              InputLogin(
                validator: _validatorEmail,
                prefixIcon: Icons.account_circle,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                textEditingController: loginController,
              ),
              SizedBox(height: size.height * 0.04),
              InputLogin(
                prefixIcon: Icons.lock,
                hint: 'Senha',
                obscureText: true,
                textEditingController: passController,
              ),
              SizedBox(height: size.height * 0.035),
              _buttonLogin(),
              SizedBox(height: size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () => _confirmAccount(),
                    child: Text(
                      'Confirmar Conta',
                      textAlign: TextAlign.right,
                      style: TextStylesLogin.textLink,
                    ),
                  ),
                  InkWell(
                    onTap: () async => _forgotPassword(),
                    child: Text(
                      'Esqueci a Senha',
                      textAlign: TextAlign.center,
                      style: TextStylesLogin.textLink,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.054),
                child: Divider(
                  height: size.height * 0.02,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.09),
              InkWell(
                onTap: () => _signUp(),
                child: Text(
                  'Cadastrar',
                  textAlign: TextAlign.right,
                  style: TextStylesLogin.textLink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is LoadingLoginState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'Entrando  ',
            mOnPressed: () => {},
          );
        } else if (state is LoggedState) {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Connectado!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Entrar',
            mOnPressed: () {
              // _loginCognito();
              // BlocProvider.of<AuthBloc>(context).add(LoginEvent(
              //     login: loginController.text, password: passController.text)),
              context
                  .read<AuthCubit>()
                  .loginEvent(loginController.text, passController.text);
            },
          );
        }
      },
    );
  }

  String? _validatorEmail(value) {
    if (!regExp.hasMatch(value)) {
      return "type a valid email";
    }
    return null;
  }

  _forgotPassword() {
    if (regExp.hasMatch(loginController.text)) {
      Navigator.push(
        context,
        SlideDownRoute(
          page: ForgotPasswordScreen(
            email: loginController.text,
          ),
        ),
      );
    } else {
      ShowAlert.open(
        context: context,
        titleText: 'Alert',
        contentText: 'Please type a valid Email in login field',
      );
    }
  }

  _confirmAccount() {
    if (regExp.hasMatch(loginController.text))
      Navigator.push(
          context,
          SlideDownRoute(
              page: ConfirmSignUpScreen(
            email: loginController.text,
          )));
    else
      ShowAlert.open(
        context: context,
        titleText: 'Alert',
        contentText: 'Please type a valid Email in login field.',
      );
  }

  _signUp() {
    Navigator.push(context, SlideLeftRoute(page: SignUpScreen()));
  }
}

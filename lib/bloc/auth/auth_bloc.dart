import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/services/wifi.dart';
import 'package:flutter_login_setup_cognito/shared/utils/exceptions.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  get initialState => LoggedOutState();

  bool _isConnectedRemote = false;
  get isConnectedRemote => _isConnectedRemote;
  bool _isConnectedLocal = false;
  get isConnectedLocal => _isConnectedLocal;

  Map<String, String> _userAttrs;
  Map<String, String> get userAttrs => _userAttrs;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      // Login event
      if (event is LoginEvent) {
        yield LoadingLoginState();

        _isConnectedRemote = await Locator.instance
            .get<UserCognito>()
            .login(event.login, event.password);

        _isConnectedLocal =
            await Locator.instance.get<FirmwareApi>().isDeviceConnected();

        yield _handleLogin(
            isConnectedLocal: _isConnectedLocal,
            isConnectedRemote: _isConnectedRemote);
        // if (_isConnectedLocal)
        //   yield LoggedState(
        //       message:
        //           "Você está conectado na rede local de automação da Tock!");
        // else if (_isConnectedRemote) {
        //   yield LoggedState(
        //       message: "Você está conectado na Tock pela Internet!");
        // } else
        //   yield LoginErrorState(
        //       message:
        //           "Você está desconectado da rede local de automação e da internet.\nHabilite uma das duas para conectar!");
      }
      // Logout event
      else if (event is LogoutEvent) {
        yield LoadingLogoutState();
        await Cognito.signOut();
        yield LoggedOutState();
      }
      // Forcing login Event
      else if (event is ForceLoginEvent) {
        yield ForcingLoginState();
        _isConnectedRemote =
            await Locator.instance.get<UserCognito>().verifyLogin();

        _isConnectedLocal =
            await Locator.instance.get<FirmwareApi>().isDeviceConnected();

        yield _handleLogin(
            isConnectedLocal: _isConnectedLocal,
            isConnectedRemote: _isConnectedRemote);

        // if (_isConnectedLocal)
        //   yield LoggedState(
        //       message:
        //           "Você está conectado na rede  de automação local da Tock!");
        // else if (_isConnectedRemote) {
        //   yield LoggedState(
        //       message: "Você está conectado na Tock pela Internet!");
        // } else
        //   yield LoginErrorState(
        //       message:
        //           "Você não possui uma Central Tock na sua rede e não logou no app pela internet.\nTente validar uma dos dois requisitos para entrar!");
      }
      // SignUp Event
      else if (event is SignUpEvent) {
        yield LoadingSignUpState();
        await Cognito.signUp(event.login, event.password, event.jsonAttrs);
        yield LoadedSignUpState();
      }
      // Confirm SignUp Event
      else if (event is ConfirmSignUpEvent) {
        yield LoadingConfirmSignUpState();
        await Cognito.confirmSignUp(event.email, event.confirmationCode);
        yield LoadedConfirmSignUpState();
      }
      // Resent Code Confirmation SignUp Event
      else if (event is SendCodeConfirmSignUpEvent) {
        yield LoadingSendCodeConfirmSignUpState();
        await Cognito.resendSignUp(event.email);
        yield LoadedSendCodeConfirmSignUpState();
      }
      // Forgot Password event
      else if (event is SendCodeForgotPasswordEvent) {
        yield LoadingSendCodeState();
        await Cognito.forgotPassword(event.email);
        yield LoadedSendCodeState();
      }
      // Confirm Code Forgot Password Event
      else if (event is ForgotPasswordEvent) {
        yield LoadingForgotPasswordState();
        await Cognito.confirmForgotPassword(
            event.email, event.newPassowrd, event.confirmationCode);
        yield LoadedForgotPasswordState();
      }
      // Logout State
      else {
        yield LoggedOutState();
      }
      // Error State
    } catch (e) {
      print(e.runtimeType);
      print(e.toString());

      yield LoginErrorState(message: HandleExptions.message(e));
    }
  }

  AuthState _handleLogin({isConnectedRemote, isConnectedLocal}) {
    if (isConnectedLocal && !isConnectedRemote)
      return LoggedState(
          message: "Você está conectado na rede local de automação da Tock!");
    else if (!isConnectedLocal && isConnectedRemote) {
      return LoggedState(message: "Você está conectado na Tock pela Internet!");
    } else if (isConnectedLocal && isConnectedRemote) {
      return LoggedState(
          message:
              "Você está conectado na Tock pela Internet e pela rede Local!");
    } else {
      return LoginErrorState(
          message:
              "Você não possui uma Central Tock na sua rede e não logou no app pela internet.\nTente validar uma dos dois requisitos para entrar!");
    }
  }
}

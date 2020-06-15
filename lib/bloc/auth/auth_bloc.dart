import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cognito_plugin/flutter_cognito_plugin.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/handle_exceptions.dart';
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

        // _isConnectedLocal =
        //     await Locator.instance.get<FirmwareApi>().isDeviceConnected();

        yield _handleLogin(
            isConnectedLocal: false, isConnectedRemote: _isConnectedRemote);
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

        await Locator.instance.get<UserCognito>().initialize();

        _isConnectedRemote =
            await Locator.instance.get<UserCognito>().verifyLogin();

        _isConnectedLocal =
            await Locator.instance.get<FirmwareApi>().isDeviceConnected();

        yield _handleLogin(
            isConnectedLocal: _isConnectedLocal,
            isConnectedRemote: _isConnectedRemote);
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
      yield LoginErrorState(
          message: HandleExptions.message(e), type: e.runtimeType);
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
              "Não foi possível fazer o login.\n Você não estava logado ou está sem conexão com a internet.");
    }
  }
}

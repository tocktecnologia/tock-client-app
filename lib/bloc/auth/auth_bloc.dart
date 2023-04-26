import 'package:client/shared/services/cognito/user.dart';
import 'package:client/shared/services/cognito/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/shared/utils/locator.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoggedOutState());
  bool _isConnectedRemote = false;
  get isConnectedRemote => _isConnectedRemote;
  User? _cognitoUser;
  get cognitoUser => _cognitoUser;

  Future<void> loginEvent(user, passowrd) async {
    emit(LoadingLoginState());
    try {
      await Locator.instance.get<CognitoUserService>().init();
      _cognitoUser = await Locator.instance
          .get<CognitoUserService>()
          .login(user, passowrd);
      _isConnectedRemote = cognitoUser!.hasAccess;

      emit(_isConnectedRemote ? LoggedState() : LoggedOutState());
    } catch (e) {
      emit(LoginErrorState(message: e.toString(), type: e.runtimeType));
    }
  }

  Future<void> forceLogin() async {
    emit(LoadingLoginState());
    try {
      await Locator.instance.get<CognitoUserService>().init();
      _isConnectedRemote =
          await Locator.instance.get<CognitoUserService>().checkAuthenticated();

      emit(_isConnectedRemote ? LoggedState() : LoggedOutState());
    } catch (e) {
      emit(LoginErrorState(message: e.toString(), type: e.runtimeType));
    }
  }

  Future<void> logout() async {
    emit(LoadingLogoutState());
    Locator.instance.get<CognitoUserService>().signOut();
    emit(LoggedOutState());
    try {} catch (e) {
      emit(LoginErrorState(message: e.toString(), type: e.runtimeType));
    }
  }
}

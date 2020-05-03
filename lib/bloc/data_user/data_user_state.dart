part of 'data_user_bloc.dart';

@immutable
abstract class DataUserState {}

class DataUserInitial extends DataUserState {}

class LoadingDataUser extends DataUserState {}

class LoadedDataUser extends DataUserState {
  final dataUser;
  LoadedDataUser({this.dataUser});
}

class LoadDataUserError extends DataUserState {
  final message;
  LoadDataUserError({this.message});
}

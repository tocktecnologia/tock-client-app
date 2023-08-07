part of 'data_user_bloc.dart';

abstract class DataUserState {}

class DataUserInitial extends DataUserState {}

class LoadingDataUserState extends DataUserState {}

class LoadedDataUserState extends DataUserState {
  DataUser dataUser;
  String version;
  LoadedDataUserState({required this.dataUser, required this.version});
}

class LoadDataUserErrorState extends DataUserState {
  final String message;
  LoadDataUserErrorState({required this.message});
}

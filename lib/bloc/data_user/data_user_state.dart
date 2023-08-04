part of 'data_user_bloc.dart';

abstract class DataUserState {}

class DataUserInitial extends DataUserState {}

class LoadingDataUserState extends DataUserState {}

class LoadedDataUserState extends DataUserState {
  DataUser dataUser;
  PackageInfo packageInfo;
  LoadedDataUserState({required this.dataUser, required this.packageInfo});
}

class LoadDataUserErrorState extends DataUserState {
  final String message;
  LoadDataUserErrorState({required this.message});
}

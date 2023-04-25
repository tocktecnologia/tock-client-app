part of 'data_user_bloc.dart';

abstract class DataUserState {}

class DataUserInitial extends DataUserState {}

class LoadingDataUserState extends DataUserState {}

class LoadedDataUserState extends DataUserState {
  DataUser dataUser;
  LoadedDataUserState({required this.dataUser});
}

class LoadDataUserErrorState extends DataUserState {
  final String? message;
  LoadDataUserErrorState({this.message});
}

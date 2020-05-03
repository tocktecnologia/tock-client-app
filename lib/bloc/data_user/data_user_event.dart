part of 'data_user_bloc.dart';

@immutable
abstract class DataUserEvent {}

class GetDataUserEvent extends DataUserEvent {}

class UpdateIdxDataUserEvent extends DataUserEvent {
  final oldIndex;
  final newIndex;

  UpdateIdxDataUserEvent({@required this.oldIndex, @required this.newIndex});
}

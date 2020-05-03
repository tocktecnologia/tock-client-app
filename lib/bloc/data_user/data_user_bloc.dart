import 'dart:async';

import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'data_user_event.dart';
part 'data_user_state.dart';

class DataUserBloc extends HydratedBloc<DataUserEvent, DataUserState> {
  @override
  DataUserState get initialState => super.initialState ?? DataUserInitial();

  DataUser _dataUser;
  get dataUser => _dataUser;

  @override
  Stream<DataUserState> mapEventToState(
    DataUserEvent event,
  ) async* {
    try {
      if (event is GetDataUserEvent) {
        yield LoadingDataUser();
        //await
        yield LoadedDataUser();
      }
    } catch (e) {
      yield LoadDataUserError(message: e.toString);
    }
  }

  @override
  DataUserState fromJson(Map<String, dynamic> json) {
    try {
      return DataUserInitial();
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(DataUserState state) {
    try {
      return {};
    } catch (_) {
      return null;
    }
  }
}

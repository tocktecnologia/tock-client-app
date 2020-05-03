import 'dart:async';

import 'package:flutter_login_setup_cognito/shared/model/data_user_model.dart';
import 'package:flutter_login_setup_cognito/shared/services/api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'data_user_event.dart';
part 'data_user_state.dart';

class DataUserBloc extends HydratedBloc<DataUserEvent, DataUserState> {
  @override
  DataUserState get initialState => super.initialState ?? DataUserInitial();

  DataUser _dataUser;
  get dataUser => _dataUser;

  // change devices order
  setDevices(devices) {
    _dataUser.devices = devices;
  }

  @override
  Stream<DataUserState> mapEventToState(
    DataUserEvent event,
  ) async* {
    try {
      if (event is GetDataUserEvent) {
        yield LoadingDataUserState();
        _dataUser = await Locator.instance.get<AwsApi>().getDataUser();
        yield LoadedDataUserState();
        //
      } else if (event is UpdateIdxDataUserEvent) {
        yield LoadingDataUserState();

        // update position
        Device w = dataUser.devices.removeAt(event.oldIndex);
        dataUser.devices.insert(event.newIndex, w);

        yield LoadedDataUserState();
      }
    } catch (e) {
      yield LoadDataUserErrorState(message: e.toString);
    }
  }

  @override
  DataUserState fromJson(Map<String, dynamic> json) {
    try {
      _dataUser = DataUser.fromJson(json);
      return LoadedDataUserState(dataUser: _dataUser);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(DataUserState state) {
    try {
      return _dataUser.toJson();
    } catch (_) {
      return null;
    }
  }
}

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

  @override
  Stream<DataUserState> mapEventToState(
    DataUserEvent event,
  ) async* {
    try {
      if (event is GetDataUserEvent) {
        yield LoadingDataUserState();
        final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
        yield LoadedDataUserState(dataUser: dataUser);
        //
      }
      // else if (event is GetDataUserEvent) {
      //     yield DataUserInitial();
      // }
    } catch (e) {
      yield LoadDataUserErrorState(message: e.toString);
    }
  }

  @override
  DataUserState fromJson(Map<String, dynamic> json) {
    // try {
    //   _dataUser = DataUser.fromJson(json);
    //   return LoadedDataUserState(dataUser: _dataUser);
    // } catch (_) {
    return null;
    // }
  }

  @override
  Map<String, dynamic> toJson(DataUserState state) {
    // try {
    //   return _dataUser.toJson();
    // } catch (_) {
    return null;
    // }
  }
}

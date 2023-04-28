import 'dart:async';
import 'dart:convert';

import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'data_user_state.dart';

const keyDataUser = "dataUser";
// class DataUserBloc extends HydratedBloc<DataUserEvent, DataUserState> {
//   @override
//   DataUserState get initialState => super.initialState ?? DataUserInitial();

//   @override
//   Stream<DataUserState> mapEventToState(
//     DataUserEvent event,
//   ) async* {
//     try {
//       if (event is GetDataUserEvent) {
//         yield LoadingDataUserState();
//         final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
//         yield LoadedDataUserState(dataUser: dataUser);
//         //
//       }
//       // else if (event is GetDataUserEvent) {
//       //     yield DataUserInitial();
//       // }
//     } catch (e) {
//       print(e.hasTimeout);
//       yield LoadDataUserErrorState(message: e.message);
//     }
//   }

//   @override
//   DataUserState fromJson(Map<String, dynamic> json) {
//     // try {
//     //   _dataUser = DataUser.fromJson(json);
//     //   return LoadedDataUserState(dataUser: _dataUser);
//     // } catch (_) {
//     return null;
//     // }
//   }

//   @override
//   Map<String, dynamic> toJson(DataUserState state) {
//     // try {
//     //   return _dataUser.toJson();
//     // } catch (_) {
//     return null;
//     // }
//   }
// }

class DataUserCubit extends Cubit<DataUserState> {
  DataUserCubit() : super(DataUserInitial());

  // DataUser? _dataUser;
  // DataUser? get dataUser => _dataUser;

  Future getDataUser({bool forceCloud = false}) async {
    emit(LoadingDataUserState());

    try {
      SharedPreferences? pref = await SharedPreferences.getInstance();
      String? userPref = pref.getString(keyDataUser);

      // if has data in memory
      if (userPref != null && !forceCloud) {
        // print("getting userData from shared preferences");
        Map<String, dynamic> dataUserjson =
            jsonDecode(userPref) as Map<String, dynamic>;
        final dataUser = DataUser.fromJson(dataUserjson);
        // await Future.delayed(const Duration(milliseconds: 10));
        emit(LoadedDataUserState(dataUser: dataUser));
      }
      // else, get from cloud
      else {
        // print("getting userData from cloud");
        final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
        await pref.setString(keyDataUser, jsonEncode(dataUser.toJson()));
        emit(LoadedDataUserState(dataUser: dataUser));
      }
    } catch (e) {
      emit(LoadDataUserErrorState(message: e.toString()));
    }
  }

  Future cleanDataUser() async {
    SharedPreferences? pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

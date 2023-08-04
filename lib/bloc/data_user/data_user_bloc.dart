import 'dart:async';
import 'dart:convert';

import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'data_user_state.dart';

const keyDataUser = "dataUser";

class DataUserCubit extends Cubit<DataUserState> {
  DataUserCubit() : super(DataUserInitial());

  Future getDataUser({bool forceCloud = true}) async {
    emit(LoadingDataUserState());

    try {
      SharedPreferences? pref = await SharedPreferences.getInstance();
      String? userPref = pref.getString(keyDataUser);

      // if has data in memory
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      if (userPref != null && !forceCloud) {
        print("getting userData from shared preferences");
        Map<String, dynamic> dataUserjson =
            jsonDecode(userPref) as Map<String, dynamic>;
        final dataUser = DataUser.fromJson(dataUserjson);
        // await Future.delayed(const Duration(milliseconds: 10));

        emit(LoadedDataUserState(dataUser: dataUser, packageInfo: packageInfo));
      }
      // else, get from cloud
      else {
        print("getting userData from cloud");
        final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
        await pref.setString(keyDataUser, jsonEncode(dataUser.toJson()));

        emit(LoadedDataUserState(dataUser: dataUser, packageInfo: packageInfo));
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

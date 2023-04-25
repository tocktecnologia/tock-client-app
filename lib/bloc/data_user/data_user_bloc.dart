import 'dart:async';

import 'package:client/shared/model/data_user_model.dart';
import 'package:client/shared/services/api/user_aws.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'data_user_state.dart';

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

  Future getDataUser() async {
    emit(LoadingDataUserState());
    try {
      final dataUser = await Locator.instance.get<AwsApi>().getDataUser();
      print(dataUser);
      emit(LoadedDataUserState(dataUser: dataUser));
    } catch (e) {
      emit(LoadDataUserErrorState(message: e.toString()));
    }
  }
}

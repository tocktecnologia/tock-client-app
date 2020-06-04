import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_login_setup_cognito/shared/services/firmware_api.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

class LocalConfigBloc extends HydratedBloc<ConfigEvent, ConfigState> {
  // Use previously cached initialState if it's available
  @override
  ConfigState get initialState {
    return super.initialState ?? ConfigState(false);
  }

  // Called when trying to read cached state from storage.
  // Be sure to handle any exceptions that can occur and return null
  // to indicate that there is no cached data.
  @override
  ConfigState fromJson(Map<String, dynamic> source) {
    try {
      return ConfigState(source['value'] as bool);
    } catch (_) {
      return null;
    }
  }

  // Called on each state change (transition)
  // If it returns null, then no cache updates will occur.
  // Otherwise, the returned value will be cached.
  @override
  Map<String, bool> toJson(ConfigState state) {
    try {
      return {'value': state.value};
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    switch (event) {
      case ConfigEvent.enableLocal:
        yield ConfigState(true);
        break;
      case ConfigEvent.disableLocal:
        yield ConfigState(false);
        break;
    }
  }
}

enum ConfigEvent { enableLocal, disableLocal }

class ConfigState {
  bool value;
  ConfigState(this.value);
}
// class LocalNetworkBloc
//     extends HydratedBloc<LocalNetworkEvent, LocalNetworkState> {
//   @override
//   LocalNetworkState get initialState =>
//       super.initialState ?? LocalNetworkInitial();

//   bool _localChoiced = false;
//   get localChoiced => _localChoiced;

//   @override
//   Stream<LocalNetworkState> mapEventToState(
//     LocalNetworkEvent event,
//   ) async* {
//     try {
//       if (event is VerifyLocalConnection) {
//         yield VerifingLocalConnenction();
//         bool isConnected =
//             await Locator.instance.get<FirmwareApi>().isDeviceConnected();
//         yield isConnected ? LocalConnected() : LocalDisconnected();
//       } else if (event is SaveChoiceLocal) {
//         _localChoiced = event.localChoiced;
//         yield ModeOperationChangedState();
//       }
//     } catch (e) {
//       yield VerifingLocalConnenctionError();
//     }
//   }

//   @override
//   LocalNetworkState fromJson(Map<String, dynamic> json) {
//     try {
//       return ModeOperationChangedState();
//     } catch (_) {
//       return null;
//     }
//   }

//   @override
//   Map<String, dynamic> toJson(LocalNetworkState state) {
//     try {
//       return {'localChoiced': _localChoiced};
//     } catch (_) {
//       return null;
//     }
//   }
// }

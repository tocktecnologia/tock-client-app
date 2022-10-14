import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/data_user/data_user_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/lights/lights_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/schedules/schedules_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/central/central_bloc.dart';
import 'bloc/iot_aws/iot_aws_bloc.dart';
import 'bloc/light/light_bloc.dart';
import 'bloc/local_network/local_network_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  Locator.setup();

  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CentralBloc>(
            create: (BuildContext context) => CentralBloc()),
        BlocProvider<LocalConfigBloc>(
            create: (BuildContext context) => LocalConfigBloc()),
        BlocProvider<IotAwsBloc>(
            create: (BuildContext context) => IotAwsBloc()),
        BlocProvider<SchedulesBloc>(
            create: (BuildContext context) => SchedulesBloc()),
        BlocProvider<LightBloc>(create: (BuildContext context) => LightBloc()),
        BlocProvider<LightsBloc>(
            create: (BuildContext context) => LightsBloc()),
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
        BlocProvider<DataUserBloc>(
            create: (BuildContext context) => DataUserBloc()),
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'Tock',
        home: FirstScreen(),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

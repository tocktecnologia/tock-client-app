import 'package:client/bloc/data_user/data_user_bloc.dart';
import 'package:client/bloc/mqtt/mqtt_connect/mqtt_connect_bloc.dart';
import 'package:client/screens/login/main.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  Locator.setup();

  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory:
  //       kIsWeb ? HydratedStorage.webStorageDirectory : Directory.current,
  // );

  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthCubit>(
        //   create: (BuildContext context) => AuthCubit(
        //     LoggedOutState(),
        //   ),
        // ),
        BlocProvider(create: (_) => DataUserCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => MqttConnectCubit())
      ],
      child: const MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'Tock',
        home: FirstScreen(),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().forceLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}

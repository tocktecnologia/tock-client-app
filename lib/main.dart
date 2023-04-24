import 'dart:io';

import 'package:client/screens/login/main.dart';
import 'package:client/shared/utils/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/mqtt/mqtt_bloc.dart';

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
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => MqttCubit())
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
    return LoginScreen();
  }
}

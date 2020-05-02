import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'shared/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locator.setup();

  await Locator.instance.get<UserCognito>().initialize();

  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BlocAuth>(create: (BuildContext context) => BlocAuth()),
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        title: 'Bloc Login Demo',
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
    BlocProvider.of<BlocAuth>(context).add(ForceLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}

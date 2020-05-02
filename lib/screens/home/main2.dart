// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_state.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/colors.dart';
import 'package:flutter_login_setup_cognito/shared/locator.dart';
import 'package:flutter_login_setup_cognito/shared/screen_transitions/fade.transition.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen2 extends StatefulWidget {
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<String> _drawerContents = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
  ];

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
      content: Text("Essa função está sendo implementada!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(actions: _iconsStatus()),
      drawer: _drawer(),
      body: _content(),
    );
  }

  List<Widget> _iconsStatus() {
    final iconRemote = BlocProvider.of<BlocAuth>(context).isConnectedRemote
        ? Icon(Icons.cloud, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
    final iconLocal = BlocProvider.of<BlocAuth>(context).isConnectedLocal
        ? Icon(Icons.wifi_tethering, color: Colors.white)
        : Icon(Icons.portable_wifi_off, color: Colors.white30);

    return [iconLocal, SizedBox(width: 20), iconRemote, SizedBox(width: 10)];
  }

  _content() {
    return BlocBuilder<BlocAuth, AuthState>(condition: (previousState, state) {
      if (state is LoggedOutState) {
        final email = Locator.instance.get<UserCognito>().userAttrs['email'];
        Navigator.pushReplacement(
            context, FadeRoute(page: LoginScreen(login: email)));
      }
      return;
    }, builder: (context, state) {
      if (state is LoadingLogoutState) {
        return SizedBox(
          child: SpinKitWave(
            color: ColorsCustom.loginScreenUp,
          ),
        );
      } else {
        return Center();
      }
    });
  }

  Widget _drawer() {
    final email = Locator.instance.get<UserCognito>().userAttrs['email'];
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('Condomínio'),
            accountEmail: Text('$email'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/cond.png'),
            ),
            margin: EdgeInsets.zero,
            onDetailsPressed: () {
              _showDrawerContents = !_showDrawerContents;
              if (_showDrawerContents)
                _controller.reverse();
              else
                _controller.forward();
            },
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _optionsDrawer(),
                        ),
                      ),
                      // The drawer's "details" view.
                      SlideTransition(
                        position: _drawerDetailsPosition,
                        child: FadeTransition(
                          opacity: ReverseAnimation(_drawerContentsOpacity),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.add),
                                title: const Text('Add account'),
                                onTap: _showNotImplementedMessage,
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('Manage accounts'),
                                onTap: _showNotImplementedMessage,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _optionsDrawer() {
    return <Widget>[
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.plus_one)),
        title: Text('Adicionar módulo'),
        onTap: _showNotImplementedMessage,
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.build)),
        title: Text('Configurar'),
        onTap: _showNotImplementedMessage,
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.exit_to_app)),
        title: Text('Sair'),
        onTap: () => {
          BlocProvider.of<BlocAuth>(context).add(LogoutEvent()),
          Navigator.pop(context),
        },
      ),
    ];
  }
}

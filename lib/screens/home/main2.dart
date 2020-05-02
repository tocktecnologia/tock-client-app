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

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  int _currentIndex;

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

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

    // implement to get from shared preference for save state
    _currentIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Olá"),
        actions: _iconsStatus(),
        centerTitle: true,
      ),
      drawer: _drawer(),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigatioItens(),
        onTap: (int idx) {
          if (idx == 3) {
            _scaffoldKey.currentState.openDrawer();
          } else {
            setState(() {
              _currentIndex = idx;
            });
          }
        },
      ),
    );
  }

  _body() {
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

  List<BottomNavigationBarItem> _bottomNavigatioItens() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: ColorsCustom.loginScreenMiddle),
        title: Text('Painel',
            maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite, color: ColorsCustom.loginScreenMiddle),
        title: Text('+ Usados',
            maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.video_library, color: ColorsCustom.loginScreenMiddle),
        title: Text('Cenas',
            maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu, color: ColorsCustom.loginScreenMiddle),
        title: Text('Menu',
            maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
    ];
  }

  List<Widget> _iconsStatus() {
    final iconRemote = BlocProvider.of<BlocAuth>(context).isConnectedRemote
        ? Icon(Icons.cloud_done, color: Colors.white)
        : Icon(Icons.cloud_off, color: Colors.white30);
    final iconLocal = BlocProvider.of<BlocAuth>(context).isConnectedLocal
        ? Icon(Icons.wifi_tethering, color: Colors.white)
        : Icon(Icons.portable_wifi_off, color: Colors.white30);

    return [iconLocal, SizedBox(width: 20), iconRemote, SizedBox(width: 10)];
  }

  Widget _drawer() {
    final email = Locator.instance.get<UserCognito>().userAttrs['email'];
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Condomínio'),
            accountEmail: Text('$email'),
            currentAccountPicture: CircleAvatar(
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
    final mheight = 8.0;
    return <Widget>[
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.plus_one)),
        title: Text('Adicionar módulo'),
        onTap: _showNotImplementedMessage,
      ),
      Divider(
        height: mheight,
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.build)),
        title: Text('Configurar'),
        onTap: _showNotImplementedMessage,
      ),
      Divider(
        height: mheight,
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.cloud_download)),
        title: Text('Baixar Backup'),
        onTap: _showNotImplementedMessage,
      ),
      Divider(
        height: mheight,
      ),
      ListTile(
        leading: CircleAvatar(child: Icon(Icons.exit_to_app)),
        title: Text('Sair'),
        onTap: () => {
          BlocProvider.of<BlocAuth>(context).add(LogoutEvent()),
          Navigator.pop(context),
        },
      ),
      Divider(height: mheight),
    ];
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(const SnackBar(
      content: Text("Essa função está sendo implementada!"),
    ));
  }
}

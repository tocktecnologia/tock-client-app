import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_bloc.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_event.dart';
import 'package:flutter_login_setup_cognito/bloc/auth/auth_state.dart';
import 'package:flutter_login_setup_cognito/bloc/data_user/data_user_bloc.dart';
import 'package:flutter_login_setup_cognito/screens/home/cenas/main.dart';
import 'package:flutter_login_setup_cognito/screens/home/favorits.dart/main.dart';
import 'package:flutter_login_setup_cognito/screens/home/panel/main.dart';
import 'package:flutter_login_setup_cognito/screens/login/main.dart';
import 'package:flutter_login_setup_cognito/shared/services/cognito_user.dart';
import 'package:flutter_login_setup_cognito/shared/utils/colors.dart';
import 'package:flutter_login_setup_cognito/shared/utils/locator.dart';
import 'package:flutter_login_setup_cognito/shared/utils/screen_transitions/open.transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  List<Widget> _bodys = <Widget>[
    PanelScreen(),
    FavoritsScreen(),
    CenasScreen()
  ];

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingLogoutState) {
          final email = Locator.instance.get<UserCognito>().userAttrs['email'];
          Navigator.pushReplacement(
              context, OpenAndFadeTransition(LoginScreen(login: email)));
        }
      },
      child: Scaffold(
        drawerDragStartBehavior: DragStartBehavior.down,
        key: _scaffoldKey,
        drawer: _drawer(),
        body: _body(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
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
      ),
    );
  }

  Widget _body() {
    return BlocBuilder<DataUserBloc, DataUserState>(builder: (context, state) {
      if (state is LoadingDataUserState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: SpinKitWave(
                color: ColorsCustom.loginScreenUp,
              ),
            ),
            Text("Download dos dados ..."),
          ],
        );
      } else if (state is LoadedDataUserState) {
        return IndexedStack(index: _currentIndex, children: _bodys);
      } else {
        return Center(child: Text("Não foi possível recuperar os dados!"));
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
        title: Text('Grupos',
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
                        child: _optionsDrawer(),
                      ),
                      // The drawer's "details" view.
                      SlideTransition(
                        position: _drawerDetailsPosition,
                        child: FadeTransition(
                          opacity: ReverseAnimation(_drawerContentsOpacity),
                          child: _optionsConfigsDrawer(),
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

  Widget _optionsDrawer() {
    final mheight = 8.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
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
            title: Text('Download Configurações'),
            onTap: () {
              BlocProvider.of<DataUserBloc>(context).add(GetDataUserEvent());
              Navigator.pop(context);
            }),
        Divider(
          height: mheight,
        ),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.exit_to_app)),
          title: Text('Sair'),
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            Navigator.pop(context);
          },
        ),
        Divider(height: mheight),
      ],
    );
  }

  Widget _optionsConfigsDrawer() {
    return Column(
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
    );
  }

  void _showNotImplementedMessage() {
    Navigator.pop(context); // Dismiss the drawer.
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: ColorsCustom.loginScreenUp,
      duration: Duration(milliseconds: 800),
      content: Text("Essa função está sendo implementada!"),
    ));
  }
}

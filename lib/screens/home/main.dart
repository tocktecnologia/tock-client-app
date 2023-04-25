import 'package:client/screens/home/devices_screen/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_state.dart';
import 'package:client/screens/login/main.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/screen_transitions/open.transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late AnimationController _controller;
  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  late int _currentIndex;

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  final List<Widget> _bodys = <Widget>[
    const DevicesScreen(),
    const DevicesScreen(),
    // SchedulesScreen()
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

    // BlocProvider.of<DataUserBloc>(context).add(GetDataUserEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoadingLogoutState) {
            // Locator.instance.get<UserCognito>().userAttrs['email'];
            Navigator.pushReplacement(
                context, OpenAndFadeTransition(const LoginScreen()));
          }
        },
        child: _body());
  }

  Widget _body() {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      key: _scaffoldKey,
      drawer: _drawer(),
      body: IndexedStack(index: _currentIndex, children: _bodys),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _bottomNavigatioItens(),
        onTap: (int idx) {
          if (idx == _bodys.length) {
            _scaffoldKey.currentState?.openDrawer();
          } else {
            setState(() {
              _currentIndex = idx;
            });
          }
        },
      ),
    );
    // return BlocBuilder<DataUserBloc, DataUserState>(
    //   condition: (prevState, state) {
    //     if (state is LoadedDataUserState) {
    //       BlocProvider.of<LightsBloc>(context).add(
    //           UpdateDevicesFromAwsAPIEvent(devices: state.dataUser.devices));

    //       BlocProvider.of<SchedulesBloc>(context).add(
    //           UpdateSchedulesConfigsEvent(schedules: state.dataUser.schedules));

    //       BlocProvider.of<IotAwsBloc>(context).add(ConnectIotAwsEvent());
    //     } else if (state is LoadDataUserErrorState) {
    //       ShowAlert.open(
    //           context: context,
    //           contentText:
    //               "Não foi possível recuperar os dados: ${state.message}.");
    //     }
    //     return;
    //   },
    //   builder: (context, state) {
    //     if (state is LoadedDataUserState)
    //       return Scaffold(
    //         drawerDragStartBehavior: DragStartBehavior.down,
    //         key: _scaffoldKey,
    //         drawer: _drawer(),
    //         body: IndexedStack(index: _currentIndex, children: _bodys),
    //         bottomNavigationBar: BottomNavigationBar(
    //           currentIndex: _currentIndex,
    //           items: _bottomNavigatioItens(),
    //           onTap: (int idx) {
    //             if (idx == _bodys.length) {
    //               _scaffoldKey.currentState.openDrawer();
    //             } else {
    //               setState(() {
    //                 _currentIndex = idx;
    //               });
    //             }
    //           },
    //         ),
    //       );
    //     else if (state is LoadingDataUserState)
    //       return Scaffold(
    //         backgroundColor: ColorsCustom.loginScreenUp,
    //         body: Column(
    //           children: <Widget>[
    //             SizedBox(height: MediaQuery.of(context).size.height * 0.0871),
    //             Container(
    //                 child: Image.asset(
    //               'assets/images/logo.png',
    //               height: 140,
    //               fit: BoxFit.fill,
    //             )),
    //             SizedBox(height: MediaQuery.of(context).size.height * 0.020),
    //             Expanded(
    //               child: SizedBox(
    //                 child: SpinKitWave(color: Colors.white),
    //               ),
    //             ),
    //             Expanded(
    //               child: Text(
    //                 "Baixando os dados ...",
    //                 style: TextStylesLogin.textPattern,
    //               ),
    //             )
    //           ],
    //         ),
    //       );
    //     else
    //       return Container(child: Text("estado: $state"));
    //   },
    // );
  }

  _restartApp() {
    // BlocProvider.of<AuthBloc>(context).add(ForceLoginEvent());
    // Navigator.pushReplacement(context, SizeRoute(page: LoginScreen()));
  }

  List<BottomNavigationBarItem> _bottomNavigatioItens() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: ColorsCustom.loginScreenMiddle),
        label: 'Painel',
        // title: Text('Painel',
        //     maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.pie_chart, color: ColorsCustom.loginScreenMiddle),
      //   title: Text('Grupos',
      //       maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      // ),
      BottomNavigationBarItem(
        icon:
            Icon(Icons.event_available, color: ColorsCustom.loginScreenMiddle),
        label: 'Agenda',

        // title: Text('Agenda',
        //     maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu, color: ColorsCustom.loginScreenMiddle),
        label: 'Menu',

        // title: Text('Menu',
        //     maxLines: 2, style: TextStyle(color: ColorsCustom.loginScreenUp)),
      ),
    ];
  }

  Widget _drawer() {
    const email =
        "test"; //Locator.instance.get<UserCognito>().userAttrs['email'];
    const locale =
        "casa"; //Locator.instance.get<UserCognito>().userAttrs['locale'];
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text('$locale'),
            accountEmail: const Text('$email'),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/cond.png'),
            ),
            margin: EdgeInsets.zero,
            onDetailsPressed: () {
              _showDrawerContents = !_showDrawerContents;
              if (_showDrawerContents) {
                _controller.reverse();
              } else {
                _controller.forward();
              }
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
                          child: _optionsAccountDrawer(),
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
    const mheight = 8.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.plus_one)),
          title: const Text('Adicionar módulo'),
          onTap: _showNotImplementedMessage,
        ),
        const Divider(height: mheight),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.invert_colors_on)),
          title: const Text('Reservatórios'),
          onTap: () {
            //  Navigator.push(
            //   context,
            //   SlideRightRoute(
            //     page: WaterScreen(),
            //   ),
          },
        ),
        const Divider(height: mheight),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.build)),
          title: const Text('Configurar'),
          onTap: _showNotImplementedMessage,
        ),
        const Divider(height: mheight),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.cloud_download)),
          title: const Text('Download Configurações'),
          onTap: () {
            //   BlocProvider.of<DataUserBloc>(context).add(GetDataUserEvent());
            //   Navigator.pop(context);
          },
        ),
        const Divider(height: mheight),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.repeat)),
          title: const Text('Reiniciar'),
          onTap: () {
            //   Navigator.pop(context);
            //   _restartApp();
          },
        ),
        const Divider(height: mheight),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.exit_to_app)),
          title: const Text('Sair'),
          onTap: () {
            context.read<AuthCubit>().logout();
            //   BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
            Navigator.pushReplacement(
              context,
              OpenAndFadeTransition(
                const LoginScreen(),
              ),
            );
          },
        ),
        const Divider(height: mheight),
      ],
    );
  }

  Widget _optionsAccountDrawer() {
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
    // Navigator.pop(context); // Dismiss the drawer.
    // _scaffoldKey.currentState.showSnackBar(const SnackBar(
    //   backgroundColor: ColorsCustom.loginScreenUp,
    //   duration: Duration(milliseconds: 800),
    //   content: Text("Essa função está sendo implementada!"),
    // ));
  }
}

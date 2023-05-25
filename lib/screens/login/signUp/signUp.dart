import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client/bloc/auth/auth_bloc.dart';
import 'package:client/bloc/auth/auth_state.dart';
import 'package:client/screens/login/signUp/confirmation_signUp.dart';
import 'package:client/shared/utils/colors.dart';
import 'package:client/shared/utils/components.dart';
import 'package:client/shared/utils/screen_transitions/slide.transition.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final localeController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    localeController.dispose();
    passController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsCustom.loginScreenUp,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsCustom.loginScreenUp,
      ),
      body: _form(),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InputLogin(
                validator: _validatorEmail,
                prefixIcon: Icons.account_circle,
                hint: 'email',
                keyboardType: TextInputType.emailAddress,
                textEditingController: emailController,
              ),
              const SizedBox(height: 30.0),
              InputLogin(
                prefixIcon: Icons.format_color_text_rounded,
                hint: 'nome',
                keyboardType: TextInputType.text,
                textEditingController: nameController,
              ),
              const SizedBox(height: 30.0),
              InputLogin(
                prefixIcon: Icons.home,
                hint: 'Local (Casa, Condomínio, AP ...)',
                keyboardType: TextInputType.text,
                textEditingController: localeController,
              ),
              const SizedBox(height: 30.0),
              InputLogin(
                prefixIcon: Icons.lock,
                hint: 'senha',
                obscureText: true,
                textEditingController: passController,
              ),
              const SizedBox(height: 30.0),
              _buttonSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSignUp() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previusState, state) {
        if (state is LoadedSignUpState) {
          Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: ConfirmSignUpScreen(
                  email: emailController.text,
                ),
              ));
        } else if (state is LoginErrorState) {
          ShowAlert.open(context: context, contentText: state.message);
        }
        return true;
      },
      builder: (context, state) {
        if (state is LoadingSignUpState) {
          return ButtonLogin(
            isLoading: true,
            backgroundColor: Colors.white,
            label: 'loading ...',
            mOnPressed: () => {},
            fontSize: 18,
          );
        } else if (state is LoadedSignUpState) {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'Success!',
            mOnPressed: () => {},
          );
        } else {
          return ButtonLogin(
            backgroundColor: Colors.white,
            label: 'OK',
            mOnPressed: () {
              context.read<AuthCubit>().signup(
                    email: emailController.text,
                    password: passController.text,
                    name: nameController.text,
                    locale: localeController.text,
                  );
            },
          );
        }
      },
    );
  }

  String? _validatorEmail(value) {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\$");
    if (!regExp.hasMatch(value)) {
      return "type a valid email";
    }
    return null;
  }

  _signUp() {
    if (_formKey.currentState!.validate()) {}
  }
}

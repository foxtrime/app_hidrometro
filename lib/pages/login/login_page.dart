import 'package:app_hidrometro/pages/api_response.dart';
import 'package:app_hidrometro/pages/login/login_api.dart';
import 'package:app_hidrometro/pages/register_page.dart';
import 'package:app_hidrometro/pages/login/usuario.dart';
import 'package:app_hidrometro/utils/alert.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:app_hidrometro/widgets/app.button.dart';
import 'package:app_hidrometro/widgets/app.text.dart';
import 'package:flutter/material.dart';
import 'package:app_hidrometro/pages/home_page.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _focusSenha = FocusNode();

  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    Future<Usuario> future = Usuario.get();
    future.then((Usuario user) {
      if (user != null) {
        push(context, HomePage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aguas"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            AppText("CPF", "Digite o CPF",
                controller: _tLogin,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                nextFocus: _focusSenha, validator: (String text) {
              if (text.isEmpty) {
                return "Digite o CPF";
              }
              return null;
            }),
            AppText("Senha", "Digite a Senha",
                focusNode: _focusSenha,
                controller: _tSenha,
                password: true, validator: (String text) {
              if (text.isEmpty) {
                return "Digite a senha";
              }
              return null;
            }),
            AppButton(
              "Entrar",
              onPressed: _onClickLogin,
              showProgress: _showProgress,
            ),
            FlatButton(
              child: Text(
                "Cadastre-se",
                textAlign: TextAlign.center,
              ),
              onPressed: _onClickRegister,
            )
          ],
        ),
      ),
    );
  }

  void _onClickRegister() {
    push(context, RegisterPage());
  }

  void _onClickLogin() async {
    bool formOk = _formKey.currentState.validate();
    if (!formOk) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tSenha.text;

    print("Login: $login, Senha: $senha");

    setState(() {
      _showProgress = true;
    });

    ApiResponse response = await LoginApi.login(login, senha);
    if (response.ok) {
      Usuario user = response.result;

      print(">>> $user");
      push(context, HomePage(), replace: true);
    } else {
      alert(context, response.msg);
    }

    setState(() {
      _showProgress = false;
    });
  }
}

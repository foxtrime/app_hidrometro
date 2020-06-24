import 'package:app_hidrometro/pages/login/login_page.dart';
import 'package:app_hidrometro/pages/register_api.dart';
import 'package:app_hidrometro/pages/login/usuario.dart';
import 'package:app_hidrometro/utils/alert.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:app_hidrometro/widgets/app.button.dart';
import 'package:app_hidrometro/widgets/app.text.dart';
import 'package:flutter/material.dart';

import 'api_response.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _showProgress = false;

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
            AppText(
              "Nome",
              "Digite o seu Nome",
              controller: _nomeController,
              validator: (String text){
                if(text.isEmpty){
                   return "Digite o seu Nome";
                }
                return null;
              },
            ),
            AppText(
              "CPF",
              "Digite seu Cpf",
              controller: _cpfController,
              keyboardType: TextInputType.number,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite seu Cpf";
                }
                return null;
              },
            ),
            AppText(
              "Senha",
              "Digite sua senha com no minimo 6 digitos",
              controller: _senhaController,
              password: true,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite sua senha";
                }
                return null;
              },
            ),
            AppButton(
              "Cadastrar",
              onPressed: _onClickCadastrar,
              showProgress: _showProgress,
            ),
          ],
        ),
      ),
    );
  }

  void _onClickCadastrar() async{

    bool formOk = _formKey.currentState.validate();
    if (!formOk) {
      return;
    }

    String nome = _nomeController.text;
    String cpf = _cpfController.text;
    String senha = _senhaController.text;

    
  // print("nome : $nome, cpf: $cpf , senha: $senha");

   setState(() {
      _showProgress = true;
    });

    ApiResponse response = await RegisterApi.register(nome, cpf, senha);
  if(response.ok){

    Usuario user = response.result;
     print(">>> $user");
    push(context, LoginPage(), replace: true);
    alert(context, "Usuario criado com sucesso");
    }else{
      
      alert(context, response.msg);

    }
    setState(() {
      _showProgress = false;
    });
  }

}

import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao_api.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao_form_page.dart';
// import 'package:app_hidrometro/utils/alert.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:app_hidrometro/drawer_list.dart';
import 'dart:async';

import 'marcacao/marcacao_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _onClickAdicionarMarcacao() {
      push(context, MarcacaoFormPage());
      // alert(context, "Teste button?");
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("aguas"),
        ),
        body: _body(),
        drawer: DrawerList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _onClickAdicionarMarcacao,
        ));
  }

  _body() {
    Future<List<Marcacao>> marcacoes = MarcacaoApi.getMarcacoes();

    return FutureBuilder(
      future: marcacoes,
      builder: _builder,
    );
  }

  Container _builder(context, snapshot) {
    if (snapshot.hasError) {
      return Container(
        child: Center(
          child: Text("Deu Ruim ai meu patrão"),
        ),
      );
    }

    if (!snapshot.hasData) {
      return Container(
        child: (Center(
          child: CircularProgressIndicator(),
        )),
      );
    }

    List<Marcacao> marcacoes = snapshot.data;
    return _listView(marcacoes);
  }

  Container _listView(List<Marcacao> marcacoes) {
    return Container(
      child: ListView.builder(
          itemCount: marcacoes != null ? marcacoes.length : 0,
          itemBuilder: (context, index) {
            _onClickMarcacao(Marcacao m) {
              push(context, MarcacaoPage(m));
            }

            Marcacao m = marcacoes[index];
            // return Text(m.leituraMes);
            return Card(
              child: new InkWell(
                onTap: () => _onClickMarcacao(m),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Leitura do Mês: '),
                          Text(m.leituraMes)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Data da ultima Marcação: '),
                          Text(m.data),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Hora da ultima Marcação: '),
                          Text(m.hora),
                        ],
                      ),
                    ],
                  ),
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            );
          }),
    );
  }
}

import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao_api.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao_form_page.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:app_hidrometro/drawer_list.dart';
import 'dart:async';

import 'marcacao/marcacao_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Marcacao> marcacoes;

  final _streamController = StreamController<List<Marcacao>>();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    List<Marcacao> marcacoes = await MarcacaoApi.getMarcacoes();

    _streamController.add(marcacoes);

    return marcacoes;
  }

  @override
  Widget build(BuildContext context) {
    void _onClickAdicionarMarcacao() {
      push(context, MarcacaoFormPage());
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
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Dale"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Marcacao> marcacoes = snapshot.data;
        // return _listView(marcacoes);
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: _listView(marcacoes),
        );
      },
    );
  }

  Future<void> _onRefresh() {
    return _loadData();
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
                          Text(m.dia),
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

  @override
  void dispose(){
    super.dispose();

    _streamController.close();
  }
}

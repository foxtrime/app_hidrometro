import 'package:app_hidrometro/pages/api_response.dart';
import 'package:app_hidrometro/pages/endereco/endereco.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:app_hidrometro/utils/alert.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:app_hidrometro/utils/url.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'marcacao_api.dart';

class MarcacaoFormPage extends StatefulWidget {
  final Marcacao marcacao;

  MarcacaoFormPage({this.marcacao});

  _MarcacaoFormPageState createState() => _MarcacaoFormPageState();
}

class _MarcacaoFormPageState extends State<MarcacaoFormPage> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Endereco>> key = new GlobalKey();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tLeiturames = TextEditingController();
  final tData = TextEditingController();
  final thora = TextEditingController();
  // final tEnderecoId = TextEditingController();

  var _showProgress = false;

  Endereco selected;

  static List<Endereco> enderecos = new List<Endereco>();
  bool loading = true;

  void getEnderecos() async {
    try {
      final response =
          await http.get('http://'+link+'/api/endereco');
      if (response.statusCode == 200) {
        enderecos = loadEnderecos(response.body);
        print('Enderecos ${enderecos.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error?");
      }
    } catch (e) {
      print("error2?");
    }
  }

  static List<Endereco> loadEnderecos(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Endereco>((json) => Endereco.fromJson(json)).toList();
  }

  @override
  void initState() {
    getEnderecos();
    super.initState();
  }

  Widget row(Endereco endereco) {
    // print(endereco.rua);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(endereco.numHidro)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nova Marcação'),
        ),
        body: SingleChildScrollView(
          child: _francisco(),
        ));
  }

  _francisco() {
    return Stack(
      children: <Widget>[
        Container(
          child: Column(children: <Widget>[
            Padding(
                child: Container(
                  child: _body(),
                ),
                padding: EdgeInsets.all(16)),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                child: selected != null
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Rua: ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(selected.rua),
                                Text(
                                  "  Numero: ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(selected.numero)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("id: "),
                                Text(selected.id.toString())
                              ],
                            ),
                            _form()
                          ],
                        ),
                      )
                    : Container(),
              ),
            )
          ]),
        ),
      ],
    );
  }

  _form() {
    return Form(
      key: this._formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextFormField(
            controller: tLeiturames,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Leitura',
            ),
          ),
          TextFormField(
            controller: tData,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Data',
            ),
          ),
          TextFormField(
            controller: thora,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.blue, fontSize: 20),
            decoration: new InputDecoration(
              hintText: '',
              labelText: 'Hora',
            ),
          ),
          Container(
            height: 50,
            margin: new EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              color: Colors.blue,
              child: _showProgress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      "Salvar",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
              onPressed: _onClickSalvar,
            ),
          )
        ],
      ),
    );
  }

  _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          loading
              ? CircularProgressIndicator()
              : searchTextField = AutoCompleteTextField<Endereco>(
                  key: key,
                  clearOnSubmit: false,
                  suggestions: enderecos,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    hintText: "Digite o numero do Hidrometro",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  itemFilter: (item, query) {
                    return item.numHidro
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
                  },
                  itemSorter: (a, b) {
                    return a.numHidro.compareTo(b.numHidro);
                  },
                  itemSubmitted: (item) => setState(() => selected = item),
                  itemBuilder: (context, item) {
                    return row(item);
                  },
                ),
        ],
      ),
    );
  }

  _onClickSalvar() async {

    var m = Marcacao();
    m.leituraMes = tLeiturames.text;
    m.dia = tData.text;
    m.hora = thora.text;
    m.enderecoId = selected.id;

    print("Marcacao: $m");

    setState(() {
      _showProgress = true;
    });

     print("Salvar a marcação $m");

    ApiResponse<bool> response = await MarcacaoApi.save(m);

    if(response.ok) {
      alert(context, "Marcação Cadastrada com Sucesso", callback: (){
        pop(context);
      });
    }else{
      alert(context, response.msg);
    }

    setState(() {
      _showProgress = false;
    });

    print("Fim.");

  }
}

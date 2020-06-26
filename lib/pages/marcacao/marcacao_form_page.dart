import 'package:app_hidrometro/pages/endereco/endereco.dart';
// import 'package:app_hidrometro/pages/endereco/endereco_api.dart';
// import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MarcacaoFormPage extends StatefulWidget {
  @override
  _MarcacaoFormPageState createState() => _MarcacaoFormPageState();
}

class _MarcacaoFormPageState extends State<MarcacaoFormPage> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Endereco>> key = new GlobalKey();

  Endereco selected;

  static List<Endereco> enderecos = new List<Endereco>();
  bool loading = true;

  void getEnderecos() async {
    try {
      final response =
          await http.get('http://e6a8dbf8ece4.ngrok.io/api/endereco');
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
      body: _francisco(),
    );
  }

  _francisco() {
    return Column(children: [
      new Padding(
          child: new Container(child: _body()), padding: EdgeInsets.all(16.0)),
      new Padding(
          padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
          child: new Card(
              child: selected != null
                  ? new Column(children: [
                      new ListTile(
                          title: new Text(selected.numHidro),
                          trailing: new Text(selected.rua)),
                    ])
                  : new Icon(Icons.cancel))),
    ]);
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
          // Padding(
          //     padding: EdgeInsets.all(16.0),
          //     child: Card(
          //         child: selected != null
          //             ? Column(
          //                 children: <Widget>[Text(selected.numHidro)],
          //               )
          //             : Icon(Icons.cancel)))
        ],
      ),
    );
  }
}

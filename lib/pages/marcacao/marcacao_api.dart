import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class MarcacaoApi {
 static Future<List<Marcacao>> getMarcacoes() async{
   var url = 'http://e6a8dbf8ece4.ngrok.io/api/marcacao';

  print("GET > $url");

   var response = await http.get(url);

    String json = response.body;
    print(json);

    List list = convert.json.decode(json);

    List<Marcacao> marcacoes = list.map<Marcacao>((map) => Marcacao.fromJson(map)).toList();

    return marcacoes;
 }
}

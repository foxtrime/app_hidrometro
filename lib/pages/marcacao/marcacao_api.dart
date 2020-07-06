import 'package:app_hidrometro/pages/api_response.dart';
import 'package:app_hidrometro/pages/marcacao/marcacao.dart';
import 'package:app_hidrometro/utils/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class MarcacaoApi {
 static Future<List<Marcacao>> getMarcacoes() async{
   var url = 'http://'+link+'/api/marcacao';

  print("GET > $url");

   var response = await http.get(url);

    String json = response.body;
    print(json);

    List list = convert.json.decode(json);

    List<Marcacao> marcacoes = list.map<Marcacao>((map) => Marcacao.fromJson(map)).toList();

    return marcacoes;
 }

static Future<ApiResponse<bool>> save(Marcacao m) async {

  Map<String, String> headers = {
    "Content-Type": "application/json"
  };

  var url = 'http://'+link+'/api/marcacao';

  print("POST > $url");

  String json = m.toJson();

  var response = await http.post(url,body:json, headers: headers);

  print('Response status ${response.statusCode}');
  print('Response body ${response.body}');

  if(response.statusCode == 201){
    Map mapResponse = convert.json.decode(response.body);

    Marcacao marcacao = Marcacao.fromJson(mapResponse);

    print("Nova marcação: ${marcacao.id}");

    return ApiResponse.ok(true);

  }
  Map mapResponse = convert.json.decode(response.body);
  return ApiResponse.error(mapResponse["error"]);
}


}

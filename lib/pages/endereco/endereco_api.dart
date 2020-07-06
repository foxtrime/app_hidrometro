import 'package:app_hidrometro/pages/endereco/endereco.dart';
import 'package:app_hidrometro/utils/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class EnderecoApi {
 static Future<List<Endereco>> getEnderecos() async{
   var url = 'http://'+link+'/api/endereco';
      
  print("GET > $url");

   var response = await http.get(url);

    String json = response.body;
    print(json);
  
    List list = convert.json.decode(json);

    List<Endereco> enderecos = list.map<Endereco>((map) => Endereco.fromJson(map)).toList();

    print(enderecos.length);
    return enderecos;
 
 }
}

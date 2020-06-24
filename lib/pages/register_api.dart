import 'dart:convert';
import 'package:app_hidrometro/pages/api_response.dart';
import 'package:app_hidrometro/pages/login/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RegisterApi{
  static Future<ApiResponse<Usuario>> register(String nome, String cpf, String senha) async {
    
    var url = 'http://486c0ca69102.ngrok.io/api/register';

    Map<String,String> headers = { 
      'Content-type' : 'application/json',
      'Accept' : 'application/json',
    };

    Map params = {
      'name' : nome,
      'cpf' : cpf,
      'password' : senha,
    };

    String s = json.encode(params);

    var response = await http.post(url, body: s, headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    Map mapResponse = json.decode(response.body);

    if(response.statusCode == 200){
    final user = Usuario.fromJson(mapResponse);

    return ApiResponse.ok(user);
  }
  return ApiResponse.error(mapResponse["message"]);
  
  }
  
}
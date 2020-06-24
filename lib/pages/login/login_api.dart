import 'dart:convert';
import 'package:app_hidrometro/pages/api_response.dart';
import 'package:app_hidrometro/pages/login/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class LoginApi {
  static Future<ApiResponse<Usuario>> login(String login, String senha) async {
    try{
      var url = 'http://486c0ca69102.ngrok.io/api/login';

    Map<String,String> headers = { 
      "Content-type": "aplication/json"
    };

    Map params = {
      'cpf': login,
      'password': senha,
    };

    String s = json.encode(params);

    var response = await http.post(url, body: s, headers: headers);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Map mapResponse = json.decode(response.body);

  if(response.statusCode == 200){
    final user = Usuario.fromJson(mapResponse);
    
   user.save();

   Usuario user2 = await Usuario.get();
   print("user2: $user2");


    return ApiResponse.ok(user);
  }

  return ApiResponse.error(mapResponse["message"]);
   
    } catch(error, exception){
      print("Erro no login $error > $exception");

      return ApiResponse.error("Não foi possivel fazer o login");
    }
  }
}

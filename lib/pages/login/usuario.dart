import 'package:app_hidrometro/utils/prefs.dart';
import 'dart:convert' as convert;
import 'dart:async';

class Usuario {
  int id;
  String name;
  String cpf;
  String token;

  Usuario(
      {this.id, this.name, this.cpf, this.token});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cpf = json['cpf'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cpf'] = this.cpf;
    data['token'] = this.token;
    return data;
  }

  static void clear(){
    Prefs.setString("user.prefs", "");
  }

  void save(){

    Map map = toJson();
    
    String json = convert.json.encode(map);
  
    Prefs.setString("user.prefs", json);
  }

  static Future<Usuario> get() async {
    String json = await Prefs.getString("user.prefs");
    if(json.isEmpty){
      return null;
    }
    Map map = convert.json.decode(json);
    Usuario user = Usuario.fromJson(map);
    return user;
  }

  @override 
  String toString() { 
    return 'Usuario{cpf: $cpf, name: $name}';
  }

}
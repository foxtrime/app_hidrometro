import 'dart:convert' as convert;

class Marcacao {
  int id;
  String leituraMes;
  String dia;
  String hora;
  int enderecoId;

  Marcacao({this.id, this.leituraMes, this.dia, this.hora, this.enderecoId});

  Marcacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leituraMes = json['leitura_mes'];
    dia = json['dia'];
    hora = json['hora'];
    enderecoId = json['endereco_id'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leitura_mes'] = this.leituraMes;
    data['dia'] = this.dia;
    data['hora'] = this.hora;
    data['endereco_id'] = this.enderecoId;
    return data;
  }

  String toJson(){
    String json = convert.json.encode(toMap());
    return json;
  }

  @override
  String toString(){
    return 'Marcacao{leitura: $leituraMes, dia: $dia, hora: $hora, Endereçoid: $enderecoId}';
  }

}
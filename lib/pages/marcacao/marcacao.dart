class Marcacao {
  String leituraMes;
  String data;
  String hora;
  int enderecoId;

  Marcacao({this.leituraMes, this.data, this.hora, this.enderecoId});

  Marcacao.fromJson(Map<String, dynamic> json) {
    leituraMes = json['leitura_mes'];
    data = json['data'];
    hora = json['hora'];
    enderecoId = json['endereco_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leitura_mes'] = this.leituraMes;
    data['data'] = this.data;
    data['hora'] = this.hora;
    data['endereco_id'] = this.enderecoId;
    return data;
  }

}
class Endereco {
  int id;
  String numHidro;
  String rua;
  String numero;
  String bairro;
  String complemento;

  Endereco(
      {this.id,
      this.numHidro,
      this.rua,
      this.numero,
      this.bairro,
      this.complemento,
      });

  Endereco.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    numHidro = json['num_hidro'];
    rua = json['rua'];
    numero = json['numero'];
    bairro = json['bairro'];
    complemento = json['complemento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['num_hidro'] = this.numHidro;
    data['rua'] = this.rua;
    data['numero'] = this.numero;
    data['bairro'] = this.bairro;
    data['complemento'] = this.complemento;
    return data;
  }

@override 
  String toString() { 
    return '$numHidro';
  }

}
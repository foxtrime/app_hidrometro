import 'package:flutter/material.dart';

import 'marcacao.dart';

class MarcacaoPage extends StatelessWidget {
  final Marcacao marcacao;
  MarcacaoPage(this.marcacao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(marcacao.dia),
      ),
      body: _body()
    );
  }

  _body(){
    return Container();
  }


}

import 'package:app_hidrometro/pages/login/login_page.dart';
import 'package:app_hidrometro/pages/login/usuario.dart';
import 'package:app_hidrometro/utils/nav.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DrawerList extends StatelessWidget {

UserAccountsDrawerHeader _header(Usuario user) {
  return UserAccountsDrawerHeader(
    accountName: Text(user.name),
    accountEmail: Text(user.cpf),
    
  );
}


  @override
  Widget build(BuildContext context) {
    Future<Usuario> future = Usuario.get();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
             FutureBuilder<Usuario>(
               future: future, builder: (context, snapshot) {
                Usuario user = snapshot.data;
                
                return user != null ? _header(user) : Container();
              },
             ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text("Favoritos"),
              subtitle: Text("Mais Informações..."),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                print("item 1");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Sair"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => _onClickLogout(context),
            )
          ],
        ),
      ),
    );
  }
}



_onClickLogout(BuildContext context) {
  Usuario.clear();
  Navigator.pop(context);
  push(context, LoginPage(), replace: true);
}

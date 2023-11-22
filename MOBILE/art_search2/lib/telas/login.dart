// ignore_for_file: use_build_context_synchronously

import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/cadastro.dart';
import 'package:flutter/material.dart';
import 'redefinir_senha.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final txtEmail = TextEditingController();
  final txtSenha = TextEditingController();
  final _loginKey = GlobalKey<FormState>();

  var db = BD();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _loginKey,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Insira um e-mail.";
                          }
                          return null;
                        },
                        controller: txtEmail,
                        decoration: InputDecoration(
                            labelText: " E-mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "insira uma senha.";
                          }
                          return null;
                        },
                        controller: txtSenha,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: " Senha",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_loginKey.currentState!.validate()) {
                              db.getConnection().then((conn) async {
                                //pesquisa o usuario no banco de dados
                                var pesquisa = await conn.query(
                                    'select *from PI_Cliente where email=? and senha=?',
                                    [txtEmail.text, txtSenha.text]);
                                if (pesquisa.isNotEmpty) {
                                  //Pega o primeiro valor da pesquisa no banco de dados
                                  var usuario = pesquisa.first;
                                  //salva os dados do usuario
                                  UsuarioRepository.idLogado = usuario[0];
                                  UsuarioRepository.nomeLogado = usuario[1];
                                  UsuarioRepository.estaLogado = true;
                                  Navigator.pop(context);
                                } else {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Aviso'),
                                            content: const Text(
                                                'Usuario não encontrado'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ));
                                }
                              });
                            }
                          },
                          child: const Text("Continuar")),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        (const RedefinirSenha())));
                          },
                          child: const Text("Esqueceu sua senha?")),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Cadastro()));
                          },
                          child:
                              const Text("Não possui uma conta? Registre-se"))
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

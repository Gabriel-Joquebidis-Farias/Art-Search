import 'package:art_search2/bd/bd.dart';
import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final txtUsuario = TextEditingController();
  final txtSenha = TextEditingController();
  final txtEmail = TextEditingController();

  final _keyCadastro = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _keyCadastro,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: 300,
                child: Column(children: [
                  const Text(
                    "Cadastro de Usuário",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "insira um nome de usuário.";
                      }
                      return null;
                    },
                    controller: txtUsuario,
                    decoration: InputDecoration(
                        labelText: " Usuário",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "insira um e-mail válido.";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "e-mail inválido";
                      }
                      return null;
                    },
                    controller: txtEmail,
                    decoration: InputDecoration(
                        labelText: " Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "insira uma senha";
                      } else if (txtSenha.text.length < 6) {
                        return "A senha deve ter, no mínimo, 6 caracteres";
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
                      onPressed: () async {
                        if (_keyCadastro.currentState!.validate()) {
                          BD db = BD();
                          await db.getConnection().then((conn) {
                            conn.query(
                                'insert into PI_Cliente (nome,email,telefone,senha,cpf,dataNascimento) values (?,?,?,?,?,?)',
                                [
                                  txtUsuario.text,
                                  txtEmail.text,
                                  '(19) 98308-5773',
                                  txtSenha.text,
                                  '111.121.113-09',
                                  DateTime.utc(2005, 09, 22)
                                ]);
                          });
                        }
                      },
                      child: const Text("Continuar")),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Já possui uma conta? faça login"))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  String _nome = "";
  String _email = "";
  String _telefone = "";
  String _senha = "";
  String _cpf = "";
  String _nascimento = DateTime.now().toUtc().toString();

  get nome => _nome;
  set nome(value) => _nome = value;

  get email => _email;
  set email(value) => _email = value;

  get telefone => _telefone;
  set telefone(value) => _telefone = value;

  get senha => _senha;
  set senha(value) => _senha = value;

  get cpf => _cpf;
  set cpf(value) => _cpf = value;

  get nascimento => _nascimento;
  set nascimento(value) => _nascimento = value;

  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtTelefone = TextEditingController();
  final TextEditingController _txtCpf = TextEditingController();
  final TextEditingController _txtAniversario = TextEditingController();

  final _editarKey = GlobalKey<FormState>();

  BD db = BD();

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      var pesquisa = await conn.query(
          'select * from PI_Cliente where idUsuario = ?',
          [UsuarioRepository.idLogado]);
      var uLogado = pesquisa.first;
      nome = uLogado[1];
      email = uLogado[2];
      telefone = uLogado[3];
      cpf = uLogado[5];
      DateTime data = uLogado[6];
      nascimento = DateFormat('yyyy-MM-dd').format(data);
      _txtEmail.text = email;
      _txtTelefone.text = telefone;
      _txtCpf.text = cpf;
      _txtAniversario.text = nascimento;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar perfil"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            child: Form(
              key: _editarKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        NetworkImage(UsuarioRepository.imagemLogin),
                  ),
                  Text(
                    UsuarioRepository.nomeLogado,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "Email:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _txtEmail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "insira um e-mail válido.";
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "e-mail inválido";
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "Telefone:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _txtTelefone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Insira um telefone válido";
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "cpf:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _txtCpf,
                      )),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "Aniversário:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _txtAniversario,
                      )),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.green),
                            iconColor:
                                MaterialStatePropertyAll<Color>(Colors.white)),
                        onPressed: () {
                          if (_editarKey.currentState!.validate()) {
                            db.getConnection().then((conn) async {
                              try {
                                await conn.query(
                                    'update PI_Cliente set email = ?, telefone = ?, cpf = ?, dataNascimento = ? where idUsuario = ?',
                                    [
                                      _txtEmail.text,
                                      _txtTelefone.text,
                                      _txtCpf.text,
                                      _txtAniversario.text,
                                      UsuarioRepository.idLogado
                                    ]);
                              } catch (e) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text('Sucesso'),
                                          content: const Text(
                                              'Novas informações salvas'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        ));
                              }
                            });
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Sucesso'),
                                      content: const Text(
                                          'Novas informações salvas'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Ok'),
                                        ),
                                      ],
                                    ));
                          }
                        },
                        child: const Icon(Icons.save)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

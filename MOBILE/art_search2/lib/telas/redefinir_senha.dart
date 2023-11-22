import 'package:flutter/material.dart';

class RedefinirSenha extends StatefulWidget {
  const RedefinirSenha({super.key});

  @override
  State<RedefinirSenha> createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  final txtEmail = TextEditingController();
  final txtCodigo = TextEditingController();

  bool codAtivo = false;
  String mensagem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Senha"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: 300,
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const Text(
                  "Recuperar Senha",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                      labelText: " Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onChanged: (value) {
                    setState(() {
                      if (txtEmail.text != "") {
                        codAtivo = true;
                      } else {
                        codAtivo = false;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: txtCodigo,
                  decoration: InputDecoration(
                      labelText: " Código",
                      enabled: codAtivo,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
                const SizedBox(height: 10),
                Text(
                  mensagem,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      if (txtCodigo.text != "") {
                        Navigator.pop(context);
                      } else {
                        mensagem = "Digite o código correto!";
                        setState(() {});
                      }
                    },
                    child: const Text("Recuperar Senha"))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

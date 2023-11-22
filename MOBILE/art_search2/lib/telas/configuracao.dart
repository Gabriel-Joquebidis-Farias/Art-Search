import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/editar_perfil.dart';
import 'package:art_search2/telas/login.dart';
import 'package:flutter/material.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  BD db = BD();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Icon(Icons.settings), Text("Configurações")],
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(UsuarioRepository.imagemLogin),
                ),
                Text(
                  UsuarioRepository.nomeLogado,
                  style: const TextStyle(fontSize: 25),
                ),
                const Divider(),
                if (UsuarioRepository.estaLogado)
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditarPerfil()));
                      },
                      child: const Text(
                        "Editar informações de usuário",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                        setState(() {});
                      },
                      child: const Text(
                        "Fazer login",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                if (UsuarioRepository.estaLogado)
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                      onPressed: () {
                        UsuarioRepository.logout();
                        setState(() {});
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout),
                          Text(
                            "Desconectar",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )),
    );
  }
}

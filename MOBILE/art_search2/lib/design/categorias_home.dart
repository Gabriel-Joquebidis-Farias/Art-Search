import 'package:flutter/material.dart';
import '../telas/pesquisa.dart';

class CategoriasHome extends StatelessWidget {
  final String imagem;
  final String nome;

  const CategoriasHome(this.imagem, this.nome, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Pesquisa()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imagem),
              radius: 75,
            ),
            Text(
              nome,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

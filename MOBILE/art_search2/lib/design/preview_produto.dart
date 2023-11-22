import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview(this.imagem, {super.key});

  final String imagem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image(
        image: NetworkImage(imagem),
        height: 50,
      ),
      onTap: () {},
    );
  }
}

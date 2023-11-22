import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/telas/produtos.dart';
import 'package:flutter/material.dart';

class CardHome extends StatefulWidget {
  final int id;
  const CardHome(this.id, {super.key});

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  BD db = BD();

  String _img = "", _nome = "";
  double _preco = 0;

  Color _corPreco = Colors.black;
  get corPreco => _corPreco;
  set corPreco(value) => _corPreco = value;

  get img => _img;
  set img(value) => _img = value;

  get nome => _nome;
  set nome(value) => _nome = value;

  get preco => _preco;
  set preco(value) => _preco = value;

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      //pesquisa o usuario no banco de dados
      var pesquisa = await conn.query(
        'select * from PI_Produto where idProduto like ?',
        [widget.id],
      );
      var prod = pesquisa.first;
      nome = prod[2];
      if (prod[7] == 1) {
        preco = prod[8];
        corPreco = Colors.green;
      } else {
        preco = prod[5];
      }
      img = prod[1];
      conn.close();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Produtos(widget.id)));
      },
      child: Container(
        width: 200,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 7.5),
        decoration:
            BoxDecoration(border: Border.all(color: const Color(0x4BA76B12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(img),
            ),
            Text(
              nome,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              "R\$${preco.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: corPreco),
            )
          ],
        ),
      ),
    );
  }
}

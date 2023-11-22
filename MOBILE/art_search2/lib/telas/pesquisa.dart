import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/model/produto.dart';
import 'package:flutter/material.dart';
import '../design/card_pesquisa.dart';

class Pesquisa extends StatefulWidget {
  const Pesquisa({super.key});

  @override
  State<Pesquisa> createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {
  final txtPesquisa = TextEditingController();
  BD db = BD();

  //final List<Produto> _listaprodutos = ProdutoRepository.getListaProdutos;
  //List<Produto> _pesquisa = [];
  List<Produto> pesquisados = [];

  @override
  void initState() {
    //_pesquisa = List.from(_listaprodutos);
    super.initState();
    pesquisados.clear();
    db.getConnection().then((conn) async {
      //pesquisa o usuario no banco de dados
      var pesquisa = await conn.query(
          'select * from PI_Produto where nomeProduto like ?',
          ["%${txtPesquisa.text}%"]);
      for (var produto in pesquisa) {
        pesquisados.add(
          Produto(
            produto[0],
            "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
            produto[2].toString(),
            produto[3].toString(),
            produto[4],
            produto[5],
          ),
        );
      }
      conn.close();
      setState(() {});
    });
  }

  void atualizaPesquisa() {
    pesquisados.clear();
    db.getConnection().then((conn) async {
      //pesquisa o usuario no banco de dados
      var pesquisa = await conn.query(
          'select * from PI_Produto where nomeProduto like ?',
          ["%${txtPesquisa.text}%"]);
      for (var produto in pesquisa) {
        pesquisados.add(
          Produto(
            produto[0],
            "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
            produto[2].toString(),
            produto[3].toString(),
            produto[4],
            produto[5],
          ),
        );
      }
      conn.close();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txtPesquisa,
                    decoration: const InputDecoration(labelText: "Pesquisa"),
                    onChanged: (value) {
                      if (txtPesquisa.text.isEmpty) {
                        atualizaPesquisa();
                      }
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      atualizaPesquisa();
                    },
                    icon: const Icon(Icons.search))
              ],
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
          child: ListView.builder(
            shrinkWrap: true,
            //separatorBuilder: (context, index) => Divider(thickness: 2),
            itemCount: pesquisados.length,
            itemBuilder: (BuildContext context, index) {
              return CardPesquisa(pesquisados[index].id);
            },
          ),
        ));
  }
}

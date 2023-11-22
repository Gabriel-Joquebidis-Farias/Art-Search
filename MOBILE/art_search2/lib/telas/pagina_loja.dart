import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/model/produto.dart';
import 'package:art_search2/telas/produtos.dart';
import 'package:flutter/material.dart';

class PaginaLoja extends StatefulWidget {
  final int idLoja;
  const PaginaLoja(this.idLoja, {super.key});

  @override
  State<PaginaLoja> createState() => _PaginaLojaState();
}

class _PaginaLojaState extends State<PaginaLoja> {
  List<Produto> pesquisa = [];
  BD db = BD();
  String _nomeLoja = "",
      _endereco = "",
      _proprietario = "",
      _telefone = "",
      _imagem = "";

  get nomeLoja => _nomeLoja;
  set nomeLoja(value) => _nomeLoja = value;
  get proprietario => _proprietario;
  set proprietario(value) => _proprietario = value;
  get telefone => _telefone;
  set telefone(value) => _telefone = value;
  get endereco => _endereco;
  set endereco(value) => _endereco = value;
  get imagem => _imagem;
  set imagem(value) => _imagem = value;

  int tela = 0;

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      //pesquisa o usuario no banco de dados
      var dados = await conn.query(
          'select * from PI_Produto where idLoja like ?', [widget.idLoja]);
      for (var produto in dados) {
        pesquisa.add(
          Produto(produto[0], produto[1], produto[2].toString(),
              produto[3].toString(), produto[4], produto[5]),
        );
        var pesquisaLoja = await conn.query(
            'select * from PI_Papelaria where id like ?', [widget.idLoja]);
        var loja = pesquisaLoja.first;
        nomeLoja = loja[1];
        proprietario = loja[2];
        endereco = loja[3];
        telefone = loja[5];
        imagem = loja[8];
      }
      conn.close();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página Loja"),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(image: NetworkImage(imagem))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomeLoja,
                    style: const TextStyle(fontSize: 25),
                  ),
                  Text(
                    endereco,
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      BorderDirectional(top: BorderSide(color: Colors.grey))),
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(color: Colors.grey)),
                        ),
                        child: const Center(
                          child: Text(
                            "Produtos",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () {
                        tela = 0;
                        setState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(color: Colors.grey)),
                        ),
                        child: const Center(
                          child: Text(
                            "Informações",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () {
                        tela = 1;
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            //telas[tela]
            if (tela == 0)
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: pesquisa.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Produtos(pesquisa[index].id)));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(pesquisa[index].imagem))),
                          ),
                        );
                        //CardHome(pesquisa[index].id);
                      },
                    )),
              )
            else
              Expanded(
                child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          """
Proprietário: $proprietario .
Telefone: $telefone .
Endereço: $endereco
""",
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    )),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: const Icon(Icons.pin_drop)),
    );
  }
}

import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/login.dart';
import 'package:art_search2/telas/produtos.dart';
import 'package:flutter/material.dart';

class CardPesquisa extends StatefulWidget {
  final int id;
  const CardPesquisa(this.id, {super.key});

  @override
  State<CardPesquisa> createState() => _CardPesquisaState();
}

class _CardPesquisaState extends State<CardPesquisa> {
  String _nome = "", _desc = "", _img = "";
  double _preco = 0, _precoPromo = 0;

  bool _desejado = false, _emPromo = false, _noCarrinho = false;

  //preco
  double _tamPreco = 20;
  Color _corPreco = Colors.green;
  get tamPreco => _tamPreco;
  set tamPreco(value) => _tamPreco = value;
  get corPreco => _corPreco;
  set corPreco(value) => _corPreco = value;

  //doubles
  get preco => _preco;
  set preco(value) => _preco = value;
  get precoPromo => _precoPromo;
  set precoPromo(value) => _precoPromo = value;

  //strings
  get nome => _nome;
  set nome(value) => _nome = value;
  get desc => _desc;
  set desc(value) => _desc = value;
  get img => _img;
  set img(value) => _img = value;

  //bools
  get desejado => _desejado;
  set desejado(value) => _desejado = value;
  get noCarrinho => _noCarrinho;
  set noCarrinho(value) => _noCarrinho = value;
  get emPromo => _emPromo;
  set emPromo(value) => _emPromo = value;

  BD db = BD();
  @override
  void initState() {
    super.initState();

    db.getConnection().then((conn) async {
      var prodPesquisa = await conn
          .query('select * from PI_Produto where idProduto = ?', [widget.id]);
      var prod = prodPesquisa.first;
      img = prod[1];
      nome = prod[2];
      desc = prod[3];
      preco = prod[5];
      precoPromo = prod[8];

      if (prod[7] == 1) {
        emPromo = true;
        tamPreco = 10.0;
        corPreco = Colors.red;
      } else {
        emPromo = false;
      }

      var desejo = await conn.query(
          "select * from PI_ListaDesejos where idProduto = ? and idUsuario = ?",
          [widget.id, UsuarioRepository.idLogado]);

      if (desejo.isNotEmpty) {
        desejado = true;
      }

      var carrinho = await conn.query(
          "select * from PI_ItensCarrinho where idProduto = ? and idUsuario = ?",
          [widget.id, UsuarioRepository.idLogado]);

      if (carrinho.isNotEmpty) {
        noCarrinho = true;
      }
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
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(image: NetworkImage(img)),
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          nome,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        //height: 80,
                        //width: 150,
                        child: Text(
                          desc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (emPromo == false)
                            Text(
                              "R\$${preco.toString()}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
                          else
                            Text(
                              "R\$${precoPromo.toString()}",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green),
                            ),
                          const Spacer(),
                          if (desejado == false)
                            IconButton(
                                onPressed: () {
                                  if (UsuarioRepository.estaLogado) {
                                    db.getConnection().then((conn) async {
                                      await conn.query(
                                          'insert into PI_ListaDesejos (idUsuario, IdProduto, nomeProduto) values (?,?,?)',
                                          [
                                            UsuarioRepository.idLogado,
                                            widget.id,
                                            nome,
                                          ]);
                                      conn.close();
                                      desejado = true;
                                      setState(() {});
                                    });
                                  } else {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Aviso'),
                                        content: const Text(
                                            'Faça login para adicionar o item a sua lista de desejos'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login(),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: const Text("Login"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('Cancelar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.favorite))
                          else
                            IconButton(
                                onPressed: () {
                                  db.getConnection().then((conn) async {
                                    await conn.query(
                                        'delete from PI_ListaDesejos where idUsuario = ? and IdProduto = ?',
                                        [
                                          UsuarioRepository.idLogado,
                                          widget.id,
                                        ]);
                                    conn.close();
                                    desejado = false;
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(Icons.heart_broken)),
                          IconButton(
                              onPressed: () {
                                if (!noCarrinho) {
                                  db.getConnection().then((conn) async {
                                    await conn.query(
                                        'insert into PI_ItensCarrinho (IdProduto, quantidade, idUsuario) values (?,?,?)',
                                        [
                                          widget.id,
                                          1,
                                          UsuarioRepository.idLogado,
                                        ]);
                                    conn.close();
                                    noCarrinho = true;
                                    setState(() {});
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Erro"),
                                      content: const Text(
                                          "O produto já etá no carrinho"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"))
                                      ],
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.add))
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

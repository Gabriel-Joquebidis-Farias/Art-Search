import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/login.dart';
import 'package:art_search2/telas/pagina_loja.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'pesquisa.dart';

class Produtos extends StatefulWidget {
  final int idProduto;
  const Produtos(this.idProduto, {super.key});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  List<String> imagens = [
    'https://kipling.vtexassets.com/arquivos/ids/176766/I5140J99-1.jpg?v=637437511476530000',
    'https://images.tcdn.com.br/img/img_prod/1132317/mochila_kipling_de_costas_g_seoul_kipling_true_black_preta_5673_3_f9fc34b84a4dbf5b11fb4f4f06cfb6a2.jpg',
    'https://images.tcdn.com.br/img/img_prod/1132317/mochila_kipling_de_costas_g_seoul_kipling_true_black_preta_5673_2_adb93262db2c6bfb55a899df5fa9c961.jpg'
  ];

  BD db = BD();

  String _nome = "", _desc = "", _detalhes = "", _nomeLoja = "";
  double _preco = 0;
  int _quantidade = 0, _idLoja = 0;
  bool _desejado = false, _noCarrinho = false;

  set nome(value) => _nome = value;
  set desc(value) => _desc = value;
  set detalhes(value) => _detalhes = value;
  set preco(value) => _preco = value;
  set quantidade(value) => _quantidade = value;
  set desejado(value) => _desejado = value;
  set loja(value) => _idLoja = value;
  get nomeLoja => _nomeLoja;
  set nomeLoja(value) => _nomeLoja = value;
  get noCarrinho => _noCarrinho;
  set noCarrinho(value) => _noCarrinho = value;

  get nome => _nome;
  get desc => _desc;
  get detalhes => _detalhes;
  get preco => _preco;
  get quantidade => _quantidade;
  get loja => _idLoja;

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      //pesquisa o usuario no banco de dados
      var pesquisa = await conn.query(
          'select * from PI_Produto where idProduto = ?', [widget.idProduto]);
      var resultado = pesquisa.first;
      nome = resultado[2];
      desc = resultado[3];
      quantidade = resultado[4];
      preco = resultado[5];
      loja = resultado[6];

      var nomLoj = await conn.query(
          'select nome_papelaria from PI_Papelaria where id = ?',
          [resultado[6]]);
      nomeLoja = nomLoj.first[0];

      var desejo = await conn.query(
          "select * from PI_ListaDesejos where idProduto = ? and idUsuario = ?",
          [widget.idProduto, UsuarioRepository.idLogado]);

      if (desejo.isNotEmpty) {
        desejado = true;
      }

      var carrinho = await conn.query(
          "select * from PI_ItensCarrinho where idProduto = ? and idUsuario = ?",
          [widget.idProduto, UsuarioRepository.idLogado]);

      if (carrinho.isNotEmpty) {
        noCarrinho = true;
      }

      conn.close();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Icon(Icons.search), Text("ArtSearch")],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Pesquisa()));
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA76B12), Color(0xFFA71168)],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Text(
                    nomeLoja,
                    style: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaginaLoja(loja),
                      )),
                ),
                Text(
                  _nome,
                  style: const TextStyle(fontSize: 30),
                ),
                CarouselSlider(
                  options: CarouselOptions(height: 325.0, viewportFraction: 1),
                  items: [0, 1, 2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Image(image: NetworkImage(imagens[i])));
                      },
                    );
                  }).toList(),
                ),
                Text(
                  "R\$$preco",
                  style: const TextStyle(
                      fontSize: 30, color: Color.fromARGB(255, 28, 134, 31)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (UsuarioRepository.estaLogado) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Cuidado!"),
                                content: const Text(
                                    "Tem certeza que deja comprar este produto?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        String utc =
                                            ("${DateTime.now().toUtc().year}-${DateTime.now().toUtc().month}-${DateTime.now().toUtc().day}");
                                        db.getConnection().then((conn) async {
                                          conn.query(
                                              'insert into PI_Pedido (dataCompra,idUsuario,valorTotal,status,tipoEntrega) values (?,?,?,?,?)',
                                              [
                                                utc,
                                                UsuarioRepository.idLogado,
                                                preco,
                                                "pendente",
                                                "envio"
                                              ]);
                                          conn.query(
                                              'delete from PI_ItensCarrinho where idUsuario = ?',
                                              [UsuarioRepository.idLogado]);
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  "Pedido feito com sucesso"),
                                              content: const Text(
                                                  "Os produtos comprados serão enviados assim que o pagamento for confirmado"),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("OK"))
                                              ],
                                            ),
                                          );
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Sim")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancelar"))
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Erro"),
                                content: const Text(
                                    "Faça login para comprar o produto."),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Login(),
                                          ));
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancelar"))
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          "Comprar",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (!noCarrinho) {
                            db.getConnection().then((conn) async {
                              await conn.query(
                                  'insert into PI_ItensCarrinho (IdProduto, quantidade, idUsuario) values (?,?,?)',
                                  [
                                    widget.idProduto,
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
                                content:
                                    const Text("O produto já etá no carrinho"),
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
                        icon: const Icon(Icons.shopping_cart)),
                    if (_desejado == false)
                      IconButton(
                          onPressed: () {
                            db.getConnection().then((conn) async {
                              await conn.query(
                                  'insert into PI_ListaDesejos (idUsuario, IdProduto, nomeProduto) values (?,?,?)',
                                  [
                                    UsuarioRepository.idLogado,
                                    widget.idProduto,
                                    nome,
                                  ]);
                              conn.close();
                              desejado = true;
                              setState(() {});
                            });
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
                                    widget.idProduto,
                                  ]);
                              conn.close();
                              desejado = false;
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.heart_broken))
                  ],
                ),
                const Divider(),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/model/produto.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:flutter/material.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final txtTotal = TextEditingController();
  List<Produto> itensCarrinho = [];

  BD db = BD();
  double _total = 0;
  set total(value) => _total = value;
  get total => _total;

  void atualizarLista() {
    total = 0.0;
    itensCarrinho.clear();
    db.getConnection().then((conn) async {
      var itens = await conn.query(
          'select * from PI_ItensCarrinho where idUsuario = ?',
          [UsuarioRepository.idLogado]);
      for (var item in itens) {
        var prod = await conn
            .query('select * from PI_Produto where idProduto = ?', [item[1]]);
        double preco = 0;
        if (prod.first[7] == 1) {
          preco = prod.first[8];
          itensCarrinho.add(Produto(prod.first[0], prod.first[1], prod.first[2],
              prod.first[3], item[2], preco));
          total = total + (preco * item[2]);
        } else {
          preco = prod.first[5];
          itensCarrinho.add(Produto(prod.first[0], prod.first[1], prod.first[2],
              prod.first[3], item[2], preco));
          total = total + (preco * item[2]);
        }
      }
      setState(() {});
      conn.close;
    });
  }

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      var itens = await conn.query(
          'select * from PI_ItensCarrinho where idUsuario = ?',
          [UsuarioRepository.idLogado]);
      for (var item in itens) {
        var prod = await conn
            .query('select * from PI_Produto where idProduto = ?', [item[1]]);
        double preco = 0;
        if (prod.first[7] == 1) {
          preco = prod.first[8];
          itensCarrinho.add(Produto(prod.first[0], prod.first[1], prod.first[2],
              prod.first[3], item[2], preco));
          total = total + (preco * item[2]);
        } else {
          preco = prod.first[5];
          itensCarrinho.add(Produto(prod.first[0], prod.first[1], prod.first[2],
              prod.first[3], item[2], preco));
          total = total + (preco * item[2]);
        }
      }
      setState(() {});
      conn.close;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [Icon(Icons.shopping_cart), Text("Carrinho")],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const Divider(thickness: 2),
                            itemCount: itensCarrinho.length,
                            itemBuilder: (BuildContext context, index) {
                              return ListTile(
                                  title: Text(itensCarrinho[index].nome),
                                  leading: SizedBox(
                                      width: 55,
                                      child: Image(
                                          image: NetworkImage(
                                              itensCarrinho[index].imagem))),
                                  subtitle: Text(
                                      "R\$${itensCarrinho[index].preco.toString()}"),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(itensCarrinho[index]
                                              .quantidade
                                              .toString())),
                                      IconButton(
                                          onPressed: () {
                                            db
                                                .getConnection()
                                                .then((conn) async {
                                              conn.query(
                                                  'delete from PI_ItensCarrinho where idProduto = ? and idUsuario = ?',
                                                  [
                                                    itensCarrinho[index].id,
                                                    UsuarioRepository.idLogado
                                                  ]);
                                              atualizarLista();
                                            });
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ));
                            },
                          ),
                        ),
                        const Divider(),
                        Text(
                          "Total: R\$$total",
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: IconButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (itensCarrinho.isNotEmpty) {
                            String utc =
                                ("${DateTime.now().toUtc().year}-${DateTime.now().toUtc().month}-${DateTime.now().toUtc().day}");
                            db.getConnection().then((conn) async {
                              conn.query(
                                  'insert into PI_Pedido (dataCompra,idUsuario,valorTotal,status,tipoEntrega) values (?,?,?,?,?)',
                                  [
                                    utc,
                                    UsuarioRepository.idLogado,
                                    total,
                                    "pendente",
                                    "envio"
                                  ]);
                              conn.query(
                                  'delete from PI_ItensCarrinho where idUsuario = ?',
                                  [UsuarioRepository.idLogado]);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Pedido feito com sucesso"),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Erro ao fazer o pedido."),
                                content: const Text(
                                    "O carrinho não pode estar vazio"),
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
                        icon: const Icon(Icons.check)),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

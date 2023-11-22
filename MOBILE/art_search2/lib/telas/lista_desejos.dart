import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/model/produto.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/produtos.dart';
import 'package:flutter/material.dart';

class ListaDesejos extends StatefulWidget {
  const ListaDesejos({super.key});

  @override
  State<ListaDesejos> createState() => _ListaDesejosState();
}

class _ListaDesejosState extends State<ListaDesejos> {
  List<Produto> listaDesejos = [];
  BD db = BD();

  void atualizaLista() {
    db.getConnection().then((conn) async {
      listaDesejos.clear();
      //pesquisa o usuario no banco de dados
      var pesquisa = await conn.query(
          'select * from PI_ListaDesejos where idUsuario like ?',
          ["%${UsuarioRepository.idLogado}%"]);
      //adiciona os resultados a lista
      for (var desejo in pesquisa) {
        var produto = await conn
            .query('select * from PI_Produto where idProduto = ?', [desejo[2]]);
        listaDesejos.add(
          Produto(
            produto.first[0],
            produto.first[1],
            produto.first[2].toString(),
            produto.first[3],
            produto.first[4],
            produto.first[5],
          ),
        );
      }
      conn.close();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    atualizaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de Desejos")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 2),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: SizedBox(
                              width: 60,
                              child: Image(
                                image: NetworkImage(listaDesejos[index].imagem),
                              )),
                          title: Text(listaDesejos[index].nome),
                          subtitle: Text(
                            listaDesejos[index].descricao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                db.getConnection().then((conn) async {
                                  conn.query(
                                      'delete from PI_ListaDesejos where idProduto = ? and idUsuario = ?',
                                      [
                                        listaDesejos[index].id,
                                        UsuarioRepository.idLogado
                                      ]);
                                  atualizaLista();
                                  setState(() {});
                                });
                              },
                              icon: const Icon(Icons.delete)),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Produtos(listaDesejos[index].id),
                                ));
                          },
                        );
                      },
                      itemCount: listaDesejos.length)),
            )
          ],
        ),
      ),
    );
  }
}

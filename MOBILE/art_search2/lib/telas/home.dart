import 'package:art_search2/bd/bd.dart';
import 'package:art_search2/model/produto.dart';
import 'package:art_search2/repository/usuarios_repository.dart';
import 'package:art_search2/telas/carrinho.dart';
import 'package:art_search2/telas/configuracao.dart';
import 'package:art_search2/telas/lista_desejos.dart';
import 'package:art_search2/telas/login.dart';
import 'package:art_search2/telas/sobre.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../design/card_home.dart';
import '../design/categorias_home.dart';
import 'pesquisa.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> imagens = [
    'https://cdn.pixabay.com/photo/2018/08/11/18/35/school-times-3599175_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/08/01/20/00/pink-2567632_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/08/08/12/59/school-3592120_1280.jpg'
  ];

  List<Produto> promocoes = [];
  List<Produto> novos = [];
  BD db = BD();

  @override
  void initState() {
    super.initState();
    db.getConnection().then((conn) async {
      var promos =
          await conn.query('select * from PI_Produto where emPromo = 1');
      for (var prod in promos) {
        promocoes.add(Produto(
            prod[0],
            "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
            prod[2],
            prod[3],
            prod[4],
            prod[8]));
      }
      var novo =
          await conn.query('select * from PI_Produto order by idProduto desc');
      for (var prod in novo) {
        novos.add(Produto(
            prod[0],
            "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
            prod[2],
            prod[3],
            prod[4],
            prod[8]));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (UsuarioRepository.estaLogado) {}
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Icon(Icons.search), Text("ArtSearch")],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Pesquisa()));
                setState(() {});
              },
              icon: const Icon(Icons.search))
        ],
      ),
      drawer: NavigationDrawer(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                if (UsuarioRepository.estaLogado)
                  Column(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/icone.jpg'),
                        radius: 100,
                      ),
                      Text(
                        UsuarioRepository.nomeLogado,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Logout"),
                        onTap: () {
                          UsuarioRepository.logout();
                          setState(() {});
                        },
                      )
                    ],
                  )
                else
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Login/Cadastro"),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                      setState(() {});
                    },
                  ),
                const Divider(),
                if (UsuarioRepository.estaLogado)
                  Column(
                    children: [
                      ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text("Lista de Desejos"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListaDesejos()));
                          }),
                      ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: const Text("Carrinho"),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Carrinho()));
                          }),
                      const Divider(),
                    ],
                  ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Configurações"),
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Configuracoes()));
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.question_mark),
                    title: const Text("Sobre nós"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Sobre()));
                    }),
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
        child: RefreshIndicator(
          onRefresh: () async {
            novos.clear();
            promocoes.clear();
            db.getConnection().then((conn) async {
              var promos = await conn
                  .query('select * from PI_Produto where emPromo = 1');
              for (var prod in promos) {
                promocoes.add(Produto(
                    prod[0],
                    "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
                    prod[2],
                    prod[3],
                    prod[4],
                    prod[8]));
              }
              var novo = await conn
                  .query('select * from PI_Produto order by idProduto desc');
              for (var prod in novo) {
                novos.add(Produto(
                    prod[0],
                    "http://143.106.241.3/~cl201271/TCC/Codigos/imagens/utensilios.jpg",
                    prod[2],
                    prod[3],
                    prod[4],
                    prod[8]));
              }
              setState(() {});
            });
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                const SizedBox(height: 20),
                SizedBox(
                  height: 180,
                  //TODO fazer os listView
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoriasHome("assets/images/bolsa.jpg", "Mochilas"),
                      CategoriasHome("assets/images/Cadernos.jpg", "Cadernos"),
                      CategoriasHome(
                          "assets/images/Utensilios.jpg", "Utensilios"),
                      CategoriasHome("assets/images/Escrita.jpg", "Escrita"),
                      CategoriasHome(
                          "assets/images/Lancamentos.jpg", "Lançamentos"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(color: Colors.white),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Em promoção:",
                            style: TextStyle(fontSize: 25),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 320,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: promocoes.length,
                              itemBuilder: (context, index) {
                                return CardHome(promocoes[index].id);
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Novos:",
                            style: TextStyle(fontSize: 25),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 320,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: novos.length,
                              itemBuilder: (context, index) {
                                return CardHome(novos[index].id);
                              },
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      const Text(
                        "Você chegou ao final da sua página inicial.",
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Procurando por algo específico?"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Pesquisa()));
                              },
                              child: const Text(
                                "Pesquisa",
                                style: TextStyle(fontSize: 15),
                              ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

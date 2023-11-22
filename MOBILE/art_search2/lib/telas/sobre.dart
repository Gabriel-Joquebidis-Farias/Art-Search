// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Row(children: [Icon(Icons.question_mark), Text("Sobre nós")]),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 450,
          decoration: const BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [Color(0xFFA76B12), Color(0xFFA71168)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Conheça um pouco mais sobre nós!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                ),
              ),
              Text(
                "Imagine uma plataforma online que conecta clientes e e papelarias de maneira rápida, simples e eficiente.",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Essa é a proposta da nossa plataforma, que foi desenvolvida com o objetivo de facilitar o processo de compra e venda de materiais de papelaria",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Para Clientes:",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA76B12)),
                    ),
                    Text(
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFA76B12)),
                        """
Encontre papelarias de confiança em sua região!

Compre e receba seus produtos em casa com segurança ou busque eles em uma papelaria próxima, tudo de forma fácil de descomplicada.

Navegue pelo nosso extenso catálogo e dedscubra uma seleção diversificada de itens de papelaria de alta qualidade. Oferecemos desde cantas e lápis de diversas marcas renomadas até cadernos e blocos de nota elegantes, ideias para suas anotações, desenhos e rascunhos.

A Art Search é o seu destino definitivo para encontrar os melhores produtos de papelaria  
""")
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Para Papelarias:",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA76B12)),
                    ),
                    Text(
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFA76B12)),
                        """
Você tem ou trabalha em uma papelaria?

As papelarias cadastradas em nossa plataforma podem ampliar sua base de clientes e expandir seus negócios de maneira simples e eficiente.

Em resumo, a nossa plataforma é a solução perfeita para clientes em busca de produtos de qualidade, e para papelarias que desejam expandir seus negócios e atender a um público mais amplo.

Com a nossa plataforma, a compra e venda de materiais de papelaria nunca foi tão fácil e eficiente.

Acesse o nosso site para computador e descubra mais
"""),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

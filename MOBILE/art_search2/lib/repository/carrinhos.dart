import 'package:art_search2/model/item_carrinho.dart';

class ListaCarrinho {
  static final List<ItemCarrinho> _carrinhos = [
    ItemCarrinho(1, 0, 1),
    ItemCarrinho(2, 0, 1)
  ];

  static get getCarrinhos => _carrinhos;

  void adicionar(ItemCarrinho ic) {
    _carrinhos.add(ic);
  }

  void remover(ItemCarrinho ic) {
    _carrinhos.remove(ic);
  }
}

class Produto {
  final int _idProduto, _quantidade;
  final String _nome, _descricao, _imagem;
  final double _preco;

  Produto(this._idProduto, this._imagem, this._nome, this._descricao,
      this._quantidade, this._preco);

  get id => _idProduto;
  get imagem => _imagem;
  get nome => _nome;
  get descricao => _descricao;
  get quantidade => _quantidade;
  get preco => _preco;
}

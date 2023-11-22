// ignore_for_file: unused_field

class Usuario {
  int? _id;
  String? _nome;
  String? _email;
  String? _telefone;
  String? _senha;
  String? _cpf;

  Usuario(this._id, this._nome, this._email, this._telefone, this._cpf);

  Usuario.cadastro(this._email, this._nome, this._senha);

  set nome(value) => _nome = value;
  get nome => _nome;

  get email => _email;
  set email(value) => _email = value;

  get telefone => _telefone;
  set telefone(value) => _telefone = value;

  get senha => _senha;
  set senha(value) => _senha = value;

  get cpf => _cpf;
  set cpf(value) => _cpf = value;
}

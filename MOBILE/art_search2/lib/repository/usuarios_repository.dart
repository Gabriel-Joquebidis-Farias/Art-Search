import 'package:art_search2/model/usuarios.dart';

class UsuarioRepository {
  static List<Usuario> _listaUsuarios = [];

  static int _idLogado = 0;
  static String _nomeLogado = "";
  static bool estaLogado = false;
  static String _imagemLogin =
      "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png";

  static get idLogado => _idLogado;
  static set idLogado(value) => _idLogado = value;
  static get nomeLogado => _nomeLogado;
  static set nomeLogado(value) => _nomeLogado = value;
  static get imagemLogin => _imagemLogin;
  static set imagemLogin(value) => _imagemLogin = value;

  static void logout() {
    idLogado = 0;
    nomeLogado = "";
    estaLogado = false;
  }

  static get getListaUsuarios => _listaUsuarios;

  set listaUsuarios(value) => _listaUsuarios = value;

  void adicionar(Usuario us) {
    _listaUsuarios.add(us);
  }

  void remover(Usuario us) {
    _listaUsuarios.remove(us);
  }
}

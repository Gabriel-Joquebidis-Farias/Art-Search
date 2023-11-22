import 'package:shared_preferences/shared_preferences.dart';

//final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<SharedPreferences> getPreferencias() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs;
}

Future<int?> getLogin() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? logado = prefs.getInt('usuarioLogado');
  if (logado == null) {
    return null;
  } else {
    return logado;
  }
}

Future<void> logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('usuarioLogado');
}

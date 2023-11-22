import 'package:mysql1/mysql1.dart';

class BD {
  final settings = ConnectionSettings(
    host: '143.106.241.3',
    port: 3306,
    user: 'cl201280',
    password: 'cl*13092005',
    db: 'cl201280',
  );

  Future<MySqlConnection> getConnection() async {
    return await MySqlConnection.connect(settings);
  }
}

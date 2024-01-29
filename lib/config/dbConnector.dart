import 'package:mysql_client/mysql_client.dart';

// MySQL 접속
Future<MySQLConnection> dbConnector() async {
  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: "10.0.2.2",
    port: 3306,
    userName: username,
    password: userpassword,
    databaseName: userdbname, // optional
  );

  await conn.connect();

  return conn;
}

// 유저ID 중복확인
import 'package:bcrypt/bcrypt.dart';
import 'package:fluttertest/config/dbConnector.dart';

// 로그인 시 이메일, 비밀번호 일치 확인
Future<Map<String, dynamic>> LoginCheck(
    String userEmail, String userPassword) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  try {
    // Get Password in DB
    final getPassword = (await conn.execute(
        "SELECT userPassword, createdDate, userEmail, userId FROM user WHERE userEmail = :email",
        {"email": userEmail}));

    for (final row in getPassword.rows) {
      String pw = row.colAt(0).toString();
      String createdDate = row.colAt(1).toString();
      String email = row.colAt(2).toString();
      String id = row.colAt(3).toString();

      if (getPassword.isNotEmpty) {
        // check password enter password and db password(return true/false)
        final bool checkPassword = BCrypt.checkpw(userPassword, pw);
        final userData = {
          'checkUser': checkPassword,
          'userEmail': email,
          'createdDate': createdDate,
          'userId': id,
        };

        print(userData['checkUser']);

        return userData;
      }
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }

  // Exception
  // return false;
  return {'checkUser': false, 'userEmail': '', 'createdDate': ''};
}

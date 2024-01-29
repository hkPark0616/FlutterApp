import 'package:fluttertest/config/dbConnector.dart';
import 'package:fluttertest/service/hash.dart';
import 'package:mysql_client/mysql_client.dart';

// Create Accont
Future<void> insertMember(String userEmail, String password) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 비밀번호 암호화 crypto
  //final hashPw = hashPassword(password);

  // DB에 유저 정보 추가
  try {
    // bcrypt
    final hashPw = await bcryptPassword(password);

    await conn.execute(
        "INSERT INTO user (userEmail, userPassword, createdDate) VALUES (:email, :password, NOW())",
        {"email": userEmail, "password": hashPw});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

// 유저ID 중복확인
Future<bool> confirmIdCheck(String userEmail) async {
  // MySQL 접속 설정
  final conn = await dbConnector();
  //print(userEmail == 'test@asd.com');
  // 쿼리 수행 결과 저장 변수
  IResultSet? result;

  // ID 중복 확인
  try {
    // 아이디가 중복이면 1 값 반환, 중복이 아니면 0 값 반환
    // result = await conn.execute(
    //     "SELECT IFNULL((SELECT userEmail FROM user WHERE userEmail=:email), 0) as idCheck",
    //     {"email": userEmail});
    result = await conn.execute(
        "SELECT COUNT(*) FROM user WHERE userEmail = :email",
        {"email": userEmail});
    for (final row in result.rows) {
      String? cnt = row.colAt(0);
      if (cnt != '0') {
        return true;
      }
    }
    // if (result.isNotEmpty) {
    //   for (final row in result.rows) {
    //     return row.colAt(0) == '1';
    //   }
    // }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }

  // Exception
  return false;
}

import 'package:fluttertest/config/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';

Future<IResultSet?> getComments(String postId, String postNum) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  IResultSet? results;

  // 전체 댓글 불러오기(부모, 자식 댓글)
  try {
    results = await conn.execute(
        "SELECT * FROM comment_table WHERE postId = :postId && postNum = :postNum ORDER BY IF(ISNULL (parent), cmt_no, parent), seq;",
        {
          "postId": postId,
          "postNum": postNum,
        });
    // if (results.isNotEmpty || results != "null")
    if (results.numOfRows > 0) {
      return results;
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  return results;
}

Future<IResultSet?> getRecomments(
    String postId, String postNum, String commentsId) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  IResultSet? results;

  // 전체 댓글 불러오기
  try {
    results = await conn.execute(
        """SELECT postId, postNum, commentsNum, commentsWriter, commentsDate, comments, class, commentsId 
            FROM comments 
            WHERE postId = :postId && postNum = :postNum && commentsId = :commentsId &&class = 1 
            ORDER BY commentsDate ASC;""",
        {
          "postId": postId,
          "postNum": postNum,
          "commentsId": commentsId,
        });
    if (results.numOfRows > 0) {
      return results;
    }
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
  return results;
}

Future<void> insertComments(
  String? postId,
  String? postNum,
  String? commentsWriter,
  String? comments,
) async {
  // MySQL 접속 설정
  final conn = await dbConnector();
  // DB에 댓글 저장
  try {
    await conn.execute(
        """INSERT INTO comment_table(content, parent, depth, seq, date, cmt_writer, postNum, postId) 
            VALUES (:comments, NULL, 1, 1, NOW(), :commentsWriter, :postNum, :postId)""",
        {
          "comments": comments,
          "commentsWriter": commentsWriter,
          "postNum": postNum,
          "postId": postId,
        });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> insertRecomments(
  String? postId,
  String? postNum,
  String? commentsWriter,
  String? comments,
  String cmt_no,
) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 대댓글 저장
  try {
    await conn.transactional((t) async {
      await t.execute(
          """INSERT INTO comment_table(content, parent, depth, date, cmt_writer, postNum, postId, seq) 
        VALUES (:comments, :parentCmtNo, 2, NOW(), :commentsWriter, :postNum, :postId, (SELECT IFNULL(MAX(seq), 1) + 1 FROM (SELECT * FROM comment_table) AS temp WHERE parent = :parentCmtNo))""",
          {
            "comments": comments,
            "parentCmtNo": cmt_no,
            "commentsWriter": commentsWriter,
            "postNum": postNum,
            "postId": postId,
          });
    });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> deleteComments(cmt_no) async {
  final conn = await dbConnector();
  try {
    // 댓글에 달린 대댓글도 함께 삭제
    await conn.execute("""DELETE 
                          FROM comment_table
                          WHERE  cmt_no = :cmt_no || parent = :cmt_no""",
        {"cmt_no": cmt_no});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> deleteRecomments(cmt_no) async {
  final conn = await dbConnector();
  try {
    // 대댓글 삭제
    await conn.execute("""DELETE 
                          FROM comment_table
                          WHERE  cmt_no = :cmt_no""", {"cmt_no": cmt_no});
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

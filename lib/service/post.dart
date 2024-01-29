import 'package:fluttertest/config/dbConnector.dart';
import 'package:mysql_client/mysql_client.dart';

// Create Accont
Future<IResultSet?> getPost() async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // 결과를 저장할 리스트
  List<Map<String, dynamic>> postsList = [];

  IResultSet? results;

  var post;

  // 전체 게시글 불러오기
  try {
    results = await conn.execute(
        "SELECT postNum, postId, postTitle, postContent, postDate, postWriter, writerId, postLike FROM post ORDER BY postDate DESC;");
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

Future<void> insertPost(
    String? userEmail, String? userId, String? title, String? content) async {
  // MySQL 접속 설정
  final conn = await dbConnector();

  // set post id (date + userid)
  DateTime now = DateTime.now();
  String date = now.toString();
  String setPostid = date.replaceAll(RegExp('\\D'), "") + "_" + userId!;

  // DB에 게시글 저장
  try {
    await conn.execute(
        "INSERT INTO post(postId, postTitle, postContent, postDate, postWriter, writerId) VALUES (:postId, :title, :content, NOW(), :userEmail, :userId)",
        {
          "postId": setPostid,
          "title": title,
          "content": content,
          "userEmail": userEmail,
          "userId": userId,
        });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> deletePost(String? postId, String? postNum, String? postWriter,
    String? postTitle) async {
  final conn = await dbConnector();
  // DB에 게시글 삭제
  try {
    await conn.execute(
        "DELETE FROM post WHERE postId = :postId && postNum = :postNum && postWriter = :postWriter && postTitle = :postTitle;",
        {
          "postId": postId,
          "postNum": postNum,
          "postWriter": postWriter,
          "postTitle": postTitle,
        });
    await conn.execute(
        "DELETE FROM comments WHERE postId = :postId && postNum = :postNum;", {
      "postId": postId,
      "postNum": postNum,
    });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> deletePostComments(String? postId, String? postNum) async {
  final conn = await dbConnector();
  // DB에 삭제할 게시글에 해당하는 댓글도 함께 삭제
  try {
    await conn.execute(
        "DELETE FROM comments WHERE postId = :postId && postNum = :postNum;", {
      "postId": postId,
      "postNum": postNum,
    });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

Future<void> updatePost(String? postId, String? postNum, String? postTitle,
    String? postContent) async {
  final conn = await dbConnector();
  // DB에 삭제할 게시글에 해당하는 댓글도 함께 삭제
  try {
    await conn.execute(
        "UPDATE post SET postTitle = :postTitle, postContent = :postContent, postDate = NOW() WHERE postId = :postId && postNum = :postNum;",
        {
          "postId": postId,
          "postNum": postNum,
          "postTitle": postTitle,
          "postContent": postContent,
        });
  } catch (e) {
    print('Error : $e');
  } finally {
    await conn.close();
  }
}

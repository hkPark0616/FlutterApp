import 'package:flutter/material.dart';
import 'package:fluttertest/service/comment.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> recommentDialog(
    BuildContext context, commentsInfo, String? currentUser) {
  String recommentsContent = '';

  final TextEditingController recommentsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      //commentsInfo
      //postId: 20240122075000302854_23,
      //postNum: 32,
      //commentsId: 28,
      //commentsWriter: test@asd.com,
      //commentsDate: 2024-01-24 14:42:31,
      //comments: sss,
      //class: 0
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          '답글 작성',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                      commentsInfo['cmt_writer'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        commentsInfo['date'],
                        style: const TextStyle(
                          color: Color.fromARGB(255, 122, 122, 122),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Text(
                  commentsInfo['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: const Icon(
                      Icons.subdirectory_arrow_right_rounded,
                      color: Color.fromARGB(255, 116, 116, 116),
                      size: 18,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      width: 200.0,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: recommentsController,
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 200,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(),
                          onSaved: (value) => recommentsContent = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '내용을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancle'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text(
                        '알림',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      content: const Text('답글을 작성하시겠습니까?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black)),
                      actions: [
                        TextButton(
                          child: const Text('Cancle'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () async {
                            //Navigator.of(context).pop();
                            // 첫번째, 두번째 다이얼로그까지 pop
                            try {
                              // insertRecomments(
                              //     commentsInfo['postId'],
                              //     commentsInfo['postNum'],
                              //     commentsInfo['commentsWriter'],
                              //     recommentsContent,
                              //     false,
                              //     commentsInfo['commentsId']);

                              // New
                              await insertRecomments(
                                  commentsInfo['postId'],
                                  commentsInfo['postNum'],
                                  //commentsInfo['cmt_writer'],
                                  currentUser,
                                  recommentsContent,
                                  commentsInfo['cmt_no']);
                              Fluttertoast.showToast(
                                msg: '답글 작성이 완료되었습니다.',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: '잠시 후에 다시 시도해주세요.',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                gravity: ToastGravity.BOTTOM,
                              );
                            } finally {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      );
    },
  );
}

Future<void> deleteCommentsDialog(BuildContext context, cmt_no) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: const Text('댓글을 삭제하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                deleteComments(cmt_no);
                Navigator.of(context).pop();
                Fluttertoast.showToast(
                  msg: '댓글이 삭제되었습니다.',
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
          ],
        );
      });
}

Future<void> deleteRecommentsDialog(BuildContext context, cmt_no) {
  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            '알림',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: const Text('댓글을 삭제하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('Cancle'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                deleteRecomments(cmt_no);
                Fluttertoast.showToast(
                  msg: '댓글이 삭제되었습니다..',
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
          ],
        );
      });
}

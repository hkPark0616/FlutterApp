import 'package:flutter/material.dart';
import 'package:fluttertest/page/mainPage.dart';
import 'package:fluttertest/page/util.dart';
import 'package:fluttertest/service/post.dart';
import 'package:fluttertest/service/postUpdator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class WritePage extends StatefulWidget {
  final String? userId;
  final String? userEmail;
  final String? createdDate;

  const WritePage({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.createdDate,
  });

  @override
  State<WritePage> createState() => MainState();
}

class MainState extends State<WritePage> {
  var _isLoading = false;

  String title = '';
  String content = '';

  List postInfo = [];

  // 아이디와 비밀번호 정보
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _saveForm(
      String? userEmail, String? userId, String? title, String? content) async {
    setState(() {
      _isLoading = true;
    });

    try {
      insertPost(userEmail, userId, title, content);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text(
                '알림',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: const Text('잠시 후에 다시 시도해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black)),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0.7,
        backgroundColor: const Color(0xFF9F7BFF),
        title: const Text(
          '글 작성',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),
        centerTitle: true,

        actions: [
          Container(
            padding: const EdgeInsets.all(9.0),
            child: ElevatedButton(
              onPressed: () {
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
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          content: const Text('글을 작성하시겠습니까?',
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
                                _saveForm(widget.userEmail, widget.userId,
                                    title, content);
                                //Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(
                                      userEmail: widget.userEmail,
                                      userId: widget.userId,
                                      createdDate: widget.createdDate,
                                    ),
                                  ),
                                );
                                Fluttertoast.showToast(
                                  msg: '글 작성이 완료되었습니다.',
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 128, 82, 255),
                minimumSize: const Size(70, 30),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                '완료',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),

      // Post Write
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: titleController,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            labelText: '제목',
                            floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 97, 97, 97),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          onSaved: (value) => title = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '제목을 입력해주세요.';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: contentController,
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            labelText: '내용',
                            floatingLabelStyle: TextStyle(
                              color: Color.fromARGB(255, 97, 97, 97),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          maxLines: 20,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onSaved: (value) => content = value!,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '내용을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// 사용 예제
// 로그아웃 버튼이나 다른 이벤트에서 호출
//await logout();

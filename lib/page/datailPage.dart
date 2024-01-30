import 'package:flutter/material.dart';
import 'package:fluttertest/page/mainPage.dart';
import 'package:fluttertest/page/updatePage.dart';
import 'package:fluttertest/service/comment.dart';
import 'package:fluttertest/service/commentsUpdator';
import 'package:fluttertest/service/post.dart';
import 'package:fluttertest/widget/dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  // 생성자 초기화
  final dynamic content;
  const DetailPage({super.key, required this.content});

  @override
  State<DetailPage> createState() => DetailState(content: content);
}

class DetailState extends State<DetailPage> {
  // 부모에게 받은 생성자 값 초기화
  final dynamic content;
  DetailState({required this.content});

  List commentsList = [];
  int commentCnt = 0;

  late ScrollController _scrollController;

  final TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _contentsFocusNode = FocusNode();

  bool isComments = true;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      /// 컨트롤러가 SingleChildScrollView에 연결이 됐는지 안돼는지
      _scrollController.hasClients;
    });
    super.initState();
    _loadUserInfo();
    loadComments();
  }

  String? currentUser = '';
  String? currentUserId = '';
  String? currentUserCreatedDate = '';

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = prefs.getString('userEmail');
      currentUserId = prefs.getString('userId');
      currentUserCreatedDate = prefs.getString('createdDate');
    });
  }

  Future<void> loadComments() async {
    List commentsList = [];
    var commentsInfo = {};

    var list = await getComments(content['postId'], content['postNum']);
    if (list != null) {
      for (final row in list.rows) {
        commentsInfo = {
          // 'postId': row.colByName('postId'),
          // 'postNum': row.colByName('postNum'),
          // 'commentsNum': row.colByName('commentsNum'),
          // 'commentsWriter': row.colByName('commentsWriter'),
          // 'commentsDate': row.colByName('commentsDate'),
          // 'comments': row.colByName('comments'),
          // 'class': row.colByName('class'),
          // 'commentsId': row.colByName('commentsId'),

          // New
          'postId': row.colByName('postId'),
          'postNum': row.colByName('postNum'),
          'cmt_no': row.colByName('cmt_no'),
          'content': row.colByName('content'),
          'parent': row.colByName('parent'),
          'depth': row.colByName('depth'),
          'seq': row.colByName('seq'),
          'date': row.colByName('date'),
          'cmt_writer': row.colByName('cmt_writer'),
        };
        commentsList.add(commentsInfo);
      }
    }
    if (mounted) {
      setState(() {
        commentCnt = commentsList.length;
        context.read<CommentsUpdator>().updateList(commentsList);
      });
    }
    // get comments count
  }

  // 게시글 삭제
  void deleteItemEvent(
      String? postId, String? postNum, String? postWriter, String? postTitle) {
    // 해당 게시글 삭제
    deletePost(postId, postNum, postWriter, postTitle);
    // 삭제할 게시글에 해당하는 댓글도 삭제
    deletePostComments(postId, postNum);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          userEmail: currentUser,
          createdDate: currentUserCreatedDate,
          userId: currentUserId,
        ),
      ),
    );
  }

  // 메모의 정보를 저장할 변수
  //List postInfo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0.7,
        backgroundColor: const Color(0xFF9F7BFF),
        title: Text(
          content['postTitle'],
          style: const TextStyle(
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
        actions: content['postWriter'] == currentUser
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  iconSize: 24,
                  onPressed: () {
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
                            content: const Text('글을 수정하시겠습니까?',
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
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // 정의한 ContentPage의 폼 호출
                                      builder: (context) =>
                                          UpdatePage(contents: content),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  onPressed: () {
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
                            content: const Text('글을 삭제하시겠습니까?',
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
                                  deleteItemEvent(
                                      content['postId'],
                                      content['postNum'],
                                      content['postWriter'],
                                      content['postTitle']);
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: '글이 삭제되었습니다.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  },
                  iconSize: 24,
                  icon: const Icon(Icons.delete),
                ),
              ]
            : null,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF9F7BFF),
        onRefresh: () => loadComments(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              isComments = true;
            });
          },
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      content['postTitle'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      content['postWriter'] + "    " + content['postDate'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                    height: 1,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),

                  // content
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 10, bottom: 10),
                      child: Text(
                        content['postContent'],
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, bottom: 12, top: 13),
                    child: Row(
                      children: [
                        // postLike
                        const Icon(
                          Icons.thumb_up_alt,
                          color: Color.fromARGB(255, 116, 116, 116),
                          size: 17,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          content['postLike'],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 116, 116, 116),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        // post comment count
                        const Icon(
                          Icons.chat_rounded,
                          color: Color.fromARGB(255, 116, 116, 116),
                          size: 17,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          commentCnt.toString(),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 116, 116, 116),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 7),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '댓글',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 116, 116, 116),
                        ),
                      ),
                    ),
                  ),

                  // Comment
                  FutureBuilder(
                    future: loadComments(),
                    builder: (context, snapshot) {
                      commentsList =
                          context.watch<CommentsUpdator>().commentsList;

                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: commentsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          dynamic commentsInfo = commentsList[index];

                          //String postNum = commentsInfo['postNum'];
                          //String postId = commentsInfo['postId'];
                          String commentsNum = commentsInfo['cmt_no'];
                          String comments = commentsInfo['content'];
                          //String? parent = commentsInfo['parent'];
                          String depth = commentsInfo['depth'];
                          //String seq = commentsInfo['seq'];
                          String commentsDate = commentsInfo['date'];
                          String commentsWriter = commentsInfo['cmt_writer'];

                          // used to width percentage(example: width * 0.85 ==> 85% whole width)
                          double width = MediaQuery.of(context).size.width;

                          if (depth == "1") {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: index == 0
                                        ? const Divider(
                                            height: 2,
                                            thickness: 1.1,
                                            endIndent: 10,
                                            indent: 10,
                                            color: Color.fromARGB(
                                                255, 122, 122, 122),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Divider(
                                              height: 1,
                                              endIndent: 15,
                                              indent: 15,
                                              color: Color.fromARGB(
                                                  255, 122, 122, 122),
                                            ),
                                          )),
                                Container(
                                  width: width * 0.85,
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      commentsWriter == content['postWriter']
                                          ? Text(
                                              "$commentsWriter (글쓴이)",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 93, 44, 228),
                                              ),
                                            )
                                          : Text(
                                              commentsWriter,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      // Text(
                                      //   commentsWriter,
                                      //   style: commentsWriter ==
                                      //           content['postWriter']
                                      //       ? const TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //           color: Color.fromARGB(
                                      //               255, 128, 82, 255),
                                      //         )
                                      //       : const TextStyle(
                                      //           fontWeight: FontWeight.bold,
                                      //         ),
                                      // ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          commentsDate,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 122, 122, 122),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // if (depth == "1")
                                      SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () async {
                                            // FocusScope.of(context)
                                            //     .requestFocus(_contentsFocusNode);
                                            await recommentDialog(context,
                                                commentsInfo, currentUser);
                                            await loadComments();
                                          },
                                          icon: const Icon(
                                            Icons.chat_bubble,
                                            size: 15,
                                            color: Color.fromARGB(
                                                255, 116, 116, 116),
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 10,
                                      // ),
                                      if (commentsWriter == currentUser)
                                        Container(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          height: 18,
                                          width: 18,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () async {
                                              await deleteCommentsDialog(
                                                  context, commentsNum);
                                              await loadComments();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 116, 116, 116),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 15),
                                  width: width * 0.85,
                                  child: Text(
                                    comments,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              //color: const Color.fromARGB(122, 243, 211, 248),
                              margin: const EdgeInsets.only(
                                  top: 3, left: 20, right: 10, bottom: 3),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 12, top: 15),
                              decoration: const BoxDecoration(
                                  border: null,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Color.fromARGB(122, 243, 211, 248)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: const Icon(
                                          Icons
                                              .subdirectory_arrow_right_rounded,
                                          size: 20,
                                        ),
                                      ),
                                      commentsWriter == content['postWriter']
                                          ? Text(
                                              "$commentsWriter (글쓴이)",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 93, 44, 228),
                                              ),
                                            )
                                          : Text(
                                              commentsWriter,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 3),
                                        child: Text(
                                          commentsDate,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 122, 122, 122),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (commentsWriter == currentUser)
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0.0),
                                            onPressed: () async {
                                              await deleteRecommentsDialog(
                                                  context, commentsNum);
                                              await loadComments();
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: Color.fromARGB(
                                                  255, 116, 116, 116),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Container(
                                    width: width * 0.95,
                                    padding: const EdgeInsets.only(
                                        left: 30, bottom: 15, top: 10),
                                    child: Text(comments),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Comment TextFormField in bottomNavigationBar
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SizedBox(
          height: 65.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 7),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    focusNode: _contentsFocusNode,
                    style: const TextStyle(
                      color: Color(0xFF393939),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    controller: commentController,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        Fluttertoast.showToast(
                          msg: '댓글을 입력해주세요.',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return '';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '댓글을 입력해주세요',
                      fillColor: const Color.fromARGB(255, 228, 228, 228),
                      filled: true,
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      errorStyle: const TextStyle(height: 0),
                      prefixIcon: const Icon(
                        Icons.chat,
                        color: Color(0xFF9F7BFF),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          String commentText = commentController.text;
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: const Text(
                                      '알림',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: const Text('댓글을 작성하시겠습니까?',
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
                                          insertComments(
                                            content['postId'],
                                            content['postNum'],
                                            currentUser,
                                            commentText,
                                          );
                                          setState(() {
                                            commentsList =
                                                Provider.of<CommentsUpdator>(
                                                        context,
                                                        listen: false)
                                                    .commentsList;
                                          });
                                          loadComments();

                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            _scrollController.animateTo(1200,
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                curve: Curves.fastOutSlowIn);
                                          });

                                          Fluttertoast.showToast(
                                            msg: '댓글 작성이 완료되었습니다.',
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                          commentController.clear();
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            null;
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF9F7BFF),
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 255, 123, 123),
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 255, 123, 123),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

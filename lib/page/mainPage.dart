import 'package:flutter/material.dart';
import 'package:fluttertest/page/datailPage.dart';
import 'package:fluttertest/page/loginPage.dart';
import 'package:fluttertest/page/util.dart';
import 'package:fluttertest/page/writePage.dart';
import 'package:fluttertest/service/post.dart';
import 'package:fluttertest/service/postUpdator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  final String? userEmail;
  final String? createdDate;
  final String? userId;

  const MainPage(
      {super.key,
      required this.userEmail,
      required this.createdDate,
      required this.userId});

  @override
  State<MainPage> createState() => MainState();
}

class MainState extends State<MainPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String mainUserEmail = '';
  String mainCreatedDate = '';
  String mainUserId = '';

  List items = [];

  bool isLoading = false;
  late int page;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    page = 0;
    _loadUserInfo();
    loadPost();
    //getPost();

    //스크롤 감지하여 다음 페이지 불러오기
    // _scrollController.addListener(() async {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     // 다음 페이지 불러오는 함수 호출
    //     await loadMorePost();
    //   }
    // });
  }

  Future<void> loadPost() async {
    List postList = [];
    var memoInfo;

    //var list = await getPost(page);
    var list = await getPost();
    for (final row in list!.rows) {
      memoInfo = {
        'postNum': row.colByName('postNum'),
        'postId': row.colByName('postId').toString(),
        'postTitle': row.colByName('postTitle'),
        'postContent': row.colByName('postContent'),
        'postDate': row.colByName('postDate'),
        'postWriter': row.colByName('postWriter'),
        'writerId': row.colByName('writerId'),
        'postLike': row.colByName('postLike'),
      };
      postList.add(memoInfo);
    }

    items.add(postList);

    //items.addAll(postList);

    context.read<PostUpdator>().updateList(postList);
  }

  // Future<void> loadMorePost() async {
  //   setState(() {
  //     isLoading = true;
  //     page++;
  //   });

  //   try {
  //     List postList = [];
  //     var memoInfo;

  //     var list = await getPost(page);
  //     for (final row in list!.rows) {
  //       memoInfo = {
  //         'postNum': row.colByName('postNum'),
  //         'postId': row.colByName('postId'),
  //         'postTitle': row.colByName('postTitle'),
  //         'postContent': row.colByName('postContent'),
  //         'postDate': row.colByName('postDate'),
  //         'postWriter': row.colByName('postWriter'),
  //         'writerId': row.colByName('writerId'),
  //         'postLike': row.colByName('postLike'),
  //       };
  //       postList.add(memoInfo);
  //     }

  //     setState(() {
  //       items.addAll(postList);
  //       isLoading = false;
  //     });
  //   } catch (error) {
  //     print("Error loading more posts: $error");
  //     // 에러 처리 로직 추가
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  void postClickEvent(BuildContext context, int index) async {
    dynamic content = items[index];

    // 메모 리스트 업데이트 확인 변수 (false : 업데이트 되지 않음, true : 업데이트 됨)
    var isMemoUpdate = await Navigator.push(
      context,
      MaterialPageRoute(
        // 정의한 ContentPage의 폼 호출
        builder: (context) => DetailPage(content: content),
      ),
    );

    // 메모 수정이 일어날 경우, 메모 메인 페이지의 리스트 새로고침
    if (isMemoUpdate != null) {
      setState(() {
        loadPost();
        items = Provider.of<PostUpdator>(context, listen: false).postList;
      });
    }
  }

  // 공유 저장소에서 사용자 정보를 불러오는 함수
  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getEmail = prefs.getString('userEmail');
    String? getDate = prefs.getString('createdDate');
    String? getUserId = prefs.getString('userId');

    setState(() {
      if (getEmail == "null" && getDate == "null") {
        mainUserEmail = prefs.getString('userEmail')!;
        mainCreatedDate = prefs.getString('createdDate')!;
        mainUserId = prefs.getString('userId')!;
      } else {
        mainUserEmail = widget.userEmail!;
        mainCreatedDate = widget.createdDate!;
        mainUserId = widget.userId!;
      }

      // userEmail = prefs.getString('userEmail') ?? 'No email available';
      // createdDate =
      //     prefs.getString('createdDate') ?? 'No created date available';
    });
  }

  // 로그아웃 함수
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // SharedPreferences에서 사용자 정보 삭제
    prefs.remove('checkUser');
    prefs.remove('userEmail');
    prefs.remove('createdDate');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color(0xFF9F7BFF),
            leading: IconButton(
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.closeDrawer();
                  //close drawer, if drawer is open
                } else {
                  scaffoldKey.currentState!.openDrawer();
                  //open drawer, if drawer is closed
                }
              },
              icon: const Icon(Icons.list),
              iconSize: 32,
            ),
            title: const Text('PHK'),
            centerTitle: true,
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(bottom: 15),
                  height: 270, // 원하는 높이로 조절
                  decoration: const BoxDecoration(
                    color: Color(0xFF9F7BFF),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/user.jpg'),
                            radius: 60.0,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            mainUserEmail,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 7.0),
                          child: Text(
                            mainCreatedDate,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle_outlined,
                      color: Colors.grey[850],
                      size: 30,
                    ),
                    title: const Text(
                      'My Info',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      print("home is clicked");
                    },
                    // trailing: Icon(Icons.add),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.list_alt_rounded,
                      color: Colors.grey[850],
                      size: 30,
                    ),
                    title: const Text(
                      'My Post',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      print("settings is clicked");
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                      size: 30,
                    ),
                    title: const Text(
                      'question_answer',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      print("question_answer is clicked");
                    },
                  ),
                ),

                // Drawer space
                const Expanded(
                    child: Center(
                  child: null,
                )),

                // Drawer footer
                Container(
                  padding: const EdgeInsets.all(3.0),
                  color: const Color(0xFF9F7BFF),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9F7BFF),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      title: const Text(
                                        '알림',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.white,
                                      content: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('로그아웃 하시겠습니까?.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancle'),
                                        ),
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            logout();
                                            Navigator.of(context).pop();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.logout_outlined),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post list
          body: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xFF9F7BFF),
                  onRefresh: () => loadPost(),
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      items = context.watch<PostUpdator>().postList;

                      return ListView.builder(
                        controller: _scrollController,
                        //padding: const EdgeInsets.only(top: 15),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          // 메모 정보 저장
                          // 'postNum': row.colByName('postNum'),
                          // 'postId': row.colByName('postId'),
                          // 'postTitle': row.colByName('postTitle'),
                          // 'postContent': row.colByName('postContent'),
                          // 'postDate': row.colByName('postDate'),
                          // 'postWriter': row.colByName('postWriter'),
                          // 'writerId': row.colByName('writerId'),
                          // 'postLike': row.colByName('postLike'),
                          dynamic memoInfo = items[index];
                          dynamic memoId = memoInfo['postId'];
                          String memoTitle = memoInfo['postTitle'];
                          String memoContent = memoInfo['postContent'];
                          String memoDate = memoInfo['postDate'];
                          String memoWriter = memoInfo['postWriter'];
                          String memoLike = memoInfo['postLike'];

                          double width = MediaQuery.of(context).size.width;

                          return Column(
                            children: [
                              InkWell(
                                onTap: () => postClickEvent(context, index),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, top: 15),
                                      width: width * 0.85,
                                      child: Text(
                                        memoTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.85,
                                      height: 40,
                                      child: Text(
                                        memoContent,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.85,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            child: Icon(
                                              Icons.thumb_up_off_alt,
                                              size: 15,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              memoLike,
                                              style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      width: width * 0.85,
                                      child: Row(
                                        children: [
                                          Text(
                                            memoDate,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color.fromARGB(
                                                  255, 80, 80, 80),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                            child: Text(
                                              "|",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                color: Color.fromARGB(
                                                    255, 120, 120, 120),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            memoWriter,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color.fromARGB(
                                                  255, 80, 80, 80),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      indent: 10,
                                      endIndent: 10,
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    future: loadPost(),
                  ),
                ),
              ),
              // if (isLoading) // 로딩 중이면 로딩 아이콘 표시
              //   Container(
              //     padding: EdgeInsets.all(16),
              //     alignment: Alignment.center,
              //     child: CircularProgressIndicator(),
              //   ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritePage(
                    userId: mainUserId,
                    userEmail: mainUserEmail,
                    createdDate: mainCreatedDate,
                  ),
                ),
              );
            },
            heroTag: "actionButton",
            backgroundColor: const Color(0xFF755DC1),
            child: const Icon(Icons.edit),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }
}

// 사용 예제
// 로그아웃 버튼이나 다른 이벤트에서 호출
//await logout();

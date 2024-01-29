import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/page/mainPage.dart';
import 'package:fluttertest/page/registerPage.dart';
import 'package:fluttertest/page/util.dart';
import 'package:fluttertest/service/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  // 자동 로그인 여부
  bool switchValue = false;

  // 아이디와 비밀번호 정보
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // 자동 로그인
  Future<void> _setAutoLogin(Map<String, dynamic> userData) async {
    // 공유저장소에 유저의 email(id), createdDate 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userEmail', userData['userEmail']);
    prefs.setString('createdDate', userData['createdDate']);
    prefs.setString('userId', userData['userId']);
  }

  // 자동 로그인 해제
  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('createdDate');
    await prefs.remove('userId');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/back_1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(214, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 15, top: 30),
                            //   child: Image.asset(
                            //     "assets/images/vector-1.png",
                            //     width: 413,
                            //     height: 330,
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
                            // const SizedBox(
                            //   height: 10,
                            // ),

                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Log in',
                                      style: TextStyle(
                                        color: Color(0xFF755DC1),
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),

                            // ID 입력 텍스트필드
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: userIdController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF393939),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Enter your Email',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF755DC1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF837E93),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF9F7BFF),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 123, 123),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 123, 123),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // 비밀번호 입력 텍스트필드
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: passwordController,
                                textAlign: TextAlign.center,
                                obscureText: true,
                                style: const TextStyle(
                                  color: Color(0xFF393939),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Enter your Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xFF755DC1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF837E93),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xFF9F7BFF),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 123, 123),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 255, 123, 123),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            // 자동 로그인 확인 토글 스위치
                            SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '자동 로그인 ',
                                    style: TextStyle(
                                        color: Color(0xFF9F7BFF),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  CupertinoSwitch(
                                    // 부울 값으로 스위치 토글 (value)
                                    value: switchValue,
                                    activeColor: const Color(0xFF9F7BFF),
                                    onChanged: (bool? value) {
                                      // 스위치가 토글될 때 실행될 코드
                                      setState(() {
                                        switchValue = value ?? false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20),

                                  // 계정 생성 페이지로 이동하는 버튼
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          width: 1.0, color: Color(0xFF9F7BFF)),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(
                                          color: Color(0xFF9F7BFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // 로그인 버튼
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: SizedBox(
                                width: 335,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final Map<String, dynamic> userData =
                                        await LoginCheck(userIdController.text,
                                            passwordController.text);

                                    //final bool checkUser = userData['checkUser'];
                                    //print(checkUser);

                                    if (!mounted) return;
                                    if (_formKey.currentState!.validate() &&
                                        userData['checkUser']) {
                                      _formKey.currentState!.save();
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: const Text(
                                                '알림',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text('로그인 되었습니다.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              actions: [
                                                TextButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    // 자동 로그인 확인
                                                    if (switchValue == true) {
                                                      _setAutoLogin(userData);
                                                    } else {
                                                      _delAutoLogin();
                                                    }

                                                    Navigator.of(context).pop();
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                        return MainPage(
                                                          userEmail: userData[
                                                              'userEmail'],
                                                          createdDate: userData[
                                                              'createdDate'],
                                                          userId: userData[
                                                              'userId'],
                                                        );
                                                      }
                                                          // const MainPage(),
                                                          ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              title: const Text(
                                                '알림',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                  '아이디 및 비밀번호를 확인해주세요.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black)),
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
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9F7BFF),
                                  ),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertest/page/loginPage.dart';
import 'package:fluttertest/service/register.dart';
//import 'package:speech_balloon/speech_balloon.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  // 유저의 아이디와 비밀번호의 정보 저장
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController =
      TextEditingController();

  final int idLength = 8;
  final int passwordLength = 10;

  final _formKey = GlobalKey<FormState>();

  bool isIdValid = false;
  bool touchCheck = false;
  String balloonText = "아이디 중복을 확인해주세요.";
  double ballonPosition = 60;

  // 중복 체크 값 불러오기 true(중복)/false(중복 X)
  bool _idExist = false;
  isDuplicate(String email) async {
    bool check = await confirmIdCheck(email);

    return check;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back_1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 30),
                          //   child: Image.asset(
                          //     "assets/images/vector-2.png",
                          //     width: 413,
                          //     height: 300,
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          // const SizedBox(
                          //   height: 30,
                          // ),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign up',
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
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
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
                                  decoration: InputDecoration(
                                    // suffixIcon: Visibility(
                                    //     visible: true,
                                    //     child: Icon(
                                    //       Icons.check_circle_outline_outlined,
                                    //       color: Colors.grey,
                                    //       size: 30,
                                    //     )),

                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          bool result = await confirmIdCheck(
                                              userIdController.text);
                                          String text = userIdController.text;
                                          setState(() {
                                            isIdValid = result;
                                            if (text.isEmpty ||
                                                text.length < idLength ||
                                                !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                    .hasMatch(text)) {
                                              touchCheck = false;
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      title: const Text(
                                                        '알림',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      content: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            '아이디를 확인해주세요.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                              balloonText = '아이디를 확인해주세요.';
                                            } else if (isIdValid) {
                                              touchCheck = true;
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      title: const Text(
                                                        '알림',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      content: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              '이미 존재하는 아이디입니다.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } else if (!isIdValid) {
                                              touchCheck = true;
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      title: const Text(
                                                        '알림',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      content: const Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text('사용 가능한 아이디입니다.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          });

                                          // 상태에 따라 speachBalloon 텍스트 변경
                                          setState(() {
                                            if (isIdValid) {
                                              balloonText = '이미 존재하는 아이디입니다.';
                                            } else if (!isIdValid &&
                                                touchCheck) {
                                              balloonText = '사용가능한 아이디입니다.';
                                            }
                                          });
                                        },
                                        icon: touchCheck
                                            ? isIdValid
                                                ? const Icon(
                                                    Icons
                                                        .check_circle_outline_outlined,
                                                    size: 30,
                                                    color: Colors.red)
                                                : const Icon(
                                                    Icons
                                                        .check_circle_outline_outlined,
                                                    size: 30,
                                                    color: Colors.green)
                                            : const Icon(
                                                Icons
                                                    .check_circle_outline_outlined,
                                                size: 30,
                                                color: Colors.grey)),

                                    labelText: 'Create Email',
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF755DC1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF837E93),
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF9F7BFF),
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 255, 123, 123),
                                      ),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 255, 123, 123),
                                      ),
                                    ),
                                  ),
                                  //onSaved: (email) => _userEmail = email as String,
                                  onChanged: (value) async {
                                    // _formKey.currentState!.validate();
                                    // _formKey.currentState!.save();

                                    // bool result =
                                    //     await confirmIdCheck(userIdController.text);
                                    // setState(() {
                                    //   isIdValid = result;
                                    // });
                                  },
                                  validator: (value) {
                                    // id 유효성 검사
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (value.length < idLength) {
                                      return 'Email must be at least $idLength characters';
                                    } else if (!RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value)) {
                                      return 'Invalid email format';
                                    }
                                    // } else if (isIdValid) {
                                    //   return 'Exist email';
                                    // }
                                    return null;
                                  },
                                ),
                              ),

                              // Speach Balloon
                              //   Positioned(
                              //     right: 34,
                              //     bottom: ballonPosition,
                              //     child: FittedBox(
                              //       child: SpeechBalloon(
                              //         nipLocation: NipLocation.bottomRight,
                              //         offset: const Offset(-12, 0),
                              //         color: const Color.fromARGB(255, 190, 190, 190),
                              //         width: 180,
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           children: [
                              //             // Icon(
                              //             //   Icons.check,
                              //             //   color: Colors.white,
                              //             // ),
                              //             Text(
                              //               // '아이디 중복을 확인해주세요.',
                              //               balloonText,
                              //               style: const TextStyle(
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.w600,
                              //                   fontSize: 13),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // 비밀번호 입력 텍스트필드
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
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
                                labelText: 'Create Password',
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
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < passwordLength) {
                                  return 'Password must be at least $passwordLength characters';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),

                          // 비밀번호 재확인 텍스트필드
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: passwordVerifyingController,
                              textAlign: TextAlign.center,
                              obscureText: true,
                              style: const TextStyle(
                                color: Color(0xFF393939),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
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
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                } else if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),

                          // 로그인 페이지로 돌아가기
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 55,
                                  height: 50,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFF9F7BFF),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),

                                // 계정 생성 버튼

                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      bool lastCheck = await isDuplicate(
                                          userIdController.text);
                                      if (!mounted) return;
                                      if (_formKey.currentState!.validate() &&
                                          touchCheck &&
                                          !lastCheck) {
                                        _formKey.currentState!.save();
                                        insertMember(userIdController.text,
                                            passwordController.text);

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
                                                    '아이디가 생성되었습니다.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.pop(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const RegisterPage(),
                                                        ),
                                                      );
                                                      // Navigator.pop(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //     builder: (context) =>
                                                      //         const LoginPage(),
                                                      //   ),
                                                      // );
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
                                      } else if (lastCheck) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                backgroundColor: Colors.white,
                                                title: const Text(
                                                  '알림',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: const Text(
                                                    '이미 존재하는 아이디입니다.',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('닫기'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                        setState(() {
                                          isIdValid = true;
                                        });
                                      } else if (_formKey.currentState!
                                              .validate() &&
                                          !touchCheck) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
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
                                                backgroundColor: Colors.white,
                                                content: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text('아이디 중복을 확인해주세요.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('OK'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
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
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}

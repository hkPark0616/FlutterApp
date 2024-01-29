import 'package:flutter/material.dart';
import 'package:fluttertest/page/tokenCheck.dart';
import 'package:fluttertest/service/commentsUpdator';
import 'package:fluttertest/service/postUpdator.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostUpdator()),
        ChangeNotifierProvider(create: (_) => CommentsUpdator()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //
      theme: ThemeData(primarySwatch: Colors.purple),
      //darkTheme: ThemeData.dark(),
      home: const TokenCheck(),
    );
  }
}

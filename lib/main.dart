import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_forum/Home.dart';
import 'package:news_forum/publishnews.dart';

import 'firebase_options.dart';
String newsid = "";
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyB_BoDLsNgA5s_S6H1CzL3of1gxQkWpKbY',
      appId: '1:898617185912:web:62d1aa2ccd734ab663ff8d',
      messagingSenderId: '898617185912',
      projectId: 'newsforum-e3174',
      authDomain: 'newsforum-e3174.firebaseapp.com',
      storageBucket: 'newsforum-e3174.appspot.com',
      measurementId: 'G-1KF35WWYYY',),);
  }else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apna News',
      home: Home(),
    );
  }
}

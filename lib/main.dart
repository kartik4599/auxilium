import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/provider/user_provider.dart';
import 'package:instagram_demo/responses/moblie_screen_layout.dart';
import 'package:instagram_demo/responses/responsive.dart';
import 'package:instagram_demo/responses/web_screen_layout.dart';
import 'package:instagram_demo/screen/add_post.dart';
import 'package:instagram_demo/screen/login_page.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDIqlh_7ALRR6__nyRz_CPE8iuLNIm2Cbc",
          appId: "1:769964934406:web:bf36398e68b45ce7b44a87",
          messagingSenderId: "769964934406",
          projectId: "auxilium-8",
          storageBucket: "auxilium-8.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auxilium',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackground),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ReponsiveLayout(
                      webScreenLayout: MoblieScreenLayout(),
                      // webScreenLayout: WebScreenLayout(),
                      moblieScreenLayout: MoblieScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.hasError.toString()),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(
                  child: LoadingBumpingLine.circle(
                    borderColor: lightGreenColor,
                    size: 40,
                  ),
                );
              }
              return const LoginPage();
            }),
      ),
    );
  }
}

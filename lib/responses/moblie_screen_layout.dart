import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/models/user.dart' as model;
import 'package:instagram_demo/provider/user_provider.dart';
import 'package:instagram_demo/screen/add_post.dart';
import 'package:instagram_demo/screen/feed_screen.dart';
import 'package:instagram_demo/screen/profilr_screen.dart';
import 'package:instagram_demo/screen/search_screen.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MoblieScreenLayout extends StatefulWidget {
  const MoblieScreenLayout({Key? key}) : super(key: key);

  @override
  State<MoblieScreenLayout> createState() => _MoblieScreenLayoutState();
}

class _MoblieScreenLayoutState extends State<MoblieScreenLayout> {
  var _currentIndex = 0;
  late PageController pageController;

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackground,
      appBar: AppBar(elevation: 0, backgroundColor: mobileBackground, actions: [
        SizedBox(
          width: 10,
        ),
        // IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
        Image.asset("assets/Screenshot_2022-04-06_211208-removebg.png"),
        Expanded(child: Container()),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddPost()));
            },
            icon: Icon(
              Icons.add_circle,
              size: 25,
            ))
      ]),
      body: PageView(
        children: [
          const feedScreen(),
          const SearchScreen(),
          Center(child: Text("message")),
          Center(child: Text("likes")),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: greenColor,
        unselectedItemColor: secondaryColor,
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          navigationTapped(i);
        },
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: _currentIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    size: 25,
                  )
                : const Icon(
                    Icons.home,
                    size: 20,
                  ),
            title: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selectedColor: greenColor,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: _currentIndex == 1
                ? const Icon(
                    CupertinoIcons.search_circle_fill,
                    size: 25,
                  )
                : const Icon(
                    Icons.search,
                    size: 20,
                  ),
            title: Text(
              "Search",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selectedColor: greenColor,
          ),

          /// Message
          SalomonBottomBarItem(
            icon: _currentIndex == 2
                ? const Icon(
                    Icons.send_rounded,
                    size: 25,
                  )
                : const Icon(
                    Icons.send_sharp,
                    size: 20,
                  ),
            title: Text(
              "Messages",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selectedColor: greenColor,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: _currentIndex == 3
                ? const Icon(
                    Icons.favorite_rounded,
                    size: 25,
                  )
                : const Icon(
                    Icons.favorite_border,
                    size: 20,
                  ),
            title: Text(
              "Likes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selectedColor: greenColor,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: _currentIndex == 4
                ? const Icon(
                    CupertinoIcons.person_fill,
                    size: 25,
                  )
                : Icon(
                    CupertinoIcons.person,
                    size: 20,
                  ),
            title: Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selectedColor: greenColor,
          ),
        ],
      ),
    );
  }
}

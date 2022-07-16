import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/resources/auth_methods.dart';
import 'package:instagram_demo/resources/firestore_methods.dart';
import 'package:instagram_demo/screen/login_page.dart';
import 'package:instagram_demo/utils/color.dart';
// import 'package:instagram_demo/widget/post_card.dart';
import 'package:instagram_demo/widget/single_post.dart';
import 'package:loading_animations/loading_animations.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user = {};
  int postLen = 0;
  int followers = 0;
  int followering = 0;
  bool isfollowing = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .get();

      //post length
      var postsnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postsnap.docs.length;
      user = snapshot.data()!;
      followers = snapshot.data()!['followers'].length;
      followering = snapshot.data()!['following'].length;
      isfollowing = snapshot
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (er) {
      if (kDebugMode) {
        print("er");
      }
    }
  }

  TextStyle bold() {
    return const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 23, color: greenColor);
  }

  TextStyle lite() {
    return const TextStyle(
        fontWeight: FontWeight.w400, fontSize: 18, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final double wid = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: mobileBackground,
        elevation: 0,
      ),
      body: user.isEmpty
          ? Center(
              child: LoadingBumpingLine.circle(
                backgroundColor: greenColor,
                size: 70,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  //Profile Pic
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                        user['photoURL'],
                      ),
                    ),
                  ]),
                  //Username
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[500],
                        fontSize: 30),
                  ),
                  Text(user['bio'], style: lite()),
                  //follow button
                  FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? InkWell(
                          onTap: () {
                            AuthMethod().signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 40,
                              width: wid / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey.withOpacity(0.5),
                                  )
                                ],
                                color: Colors.grey,
                              ),
                              child: const Center(
                                child: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await FirestoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                user['uid']);

                            setState(() {
                              isfollowing = !isfollowing;
                              if (isfollowing) {
                                followers++;
                              } else {
                                followers--;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 40,
                              width: wid / 3,
                              decoration: BoxDecoration(
                                color: isfollowing
                                    ? Colors.grey.shade700
                                    : greenColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: isfollowing
                                    ? const Text(
                                        "Unfollow",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    : const Text(
                                        "Follow",
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          )),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                  ),
                  //Post,Followers,following
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Posts
                        Column(
                          children: [
                            Text(
                              "Posts",
                              style: bold(),
                            ),
                            Text(
                              postLen.toString(),
                              style: lite(),
                            )
                          ],
                        ),
                        //followers
                        Column(
                          children: [
                            Text(
                              "followers",
                              style: bold(),
                            ),
                            Text(
                              followers.toString(),
                              style: lite(),
                            )
                          ],
                        ),
                        //following
                        Column(
                          children: [
                            Text(
                              "following",
                              style: bold(),
                            ),
                            Text(
                              followering.toString(),
                              style: lite(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      color: Colors.white.withOpacity(0.1),
                      thickness: 0.5,
                    ),
                  ),
                  //showing all posts
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('post')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingBumpingLine.circle(),
                          );
                        }
                        return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 0.5),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  snapshot.data!.docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SinglePost(
                                              snap: snapshot.data!.docs[index]
                                                  .data())));
                                },
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(snap['postUrl'])),
                              );
                            });
                      })
                ],
              ),
            ),
    );
  }
}

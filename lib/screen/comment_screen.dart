import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/provider/user_provider.dart';
import 'package:instagram_demo/resources/firestore_methods.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:instagram_demo/widget/comment_card.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mobileBackground,
        title: const Text(
          "Comments",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingBumpingLine.circle(
                  backgroundColor: darkGreenColor,
                  size: 70,
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshot.data!.docs[index].data()),
              itemCount: snapshot.data!.docs.length,
            );
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kBottomNavigationBarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURl),
              radius: 18,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: " Comment as ${user.username}...",
                    border: InputBorder.none),
              ),
            )),
            InkWell(
              onTap: () async {
                String res = await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    _controller.text,
                    user.uid,
                    user.username,
                    user.photoURl);
                if (res == "empty") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Empty comment can't be posted",
                      style: TextStyle(),
                    ),
                  ));
                }
                if (res == "sucesss") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Successfully Posted !!",
                      style: TextStyle(),
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Some Error Occured",
                      style: TextStyle(),
                    ),
                  ));
                }
                setState(() {
                  _controller.text = "";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Text(
                  "Post",
                  style: TextStyle(color: greenColor, fontSize: 16),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

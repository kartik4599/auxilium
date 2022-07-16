import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/resources/firestore_methods.dart';
import 'package:instagram_demo/screen/comment_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../screen/profilr_screen.dart';
import '../utils/color.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentlen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentlen = snap.docs.length;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    bool _isliked = widget.snap['likes'].contains(user.uid);
    return Container(
      color: mobileBackground,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(children: [
        const Divider(
          thickness: 0.5,
          height: 5,
        ),
        //Header
        Container(
          padding: const EdgeInsets.only(left: 8, right: 0, bottom: 5)
              .copyWith(top: 0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: widget.snap['uid'])));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0, left: 10),
                      child: Text(
                        widget.snap['username'],
                        style: TextStyle(
                            fontSize: 14,
                            wordSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.snap['profImage']),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        if (user.uid == widget.snap['uid']) {
                                          await FirestoreMethods().deletePost(
                                              widget.snap['postId']);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              "You can't delete another's posts",
                                              style: TextStyle(),
                                            ),
                                          ));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 16),
                                        child: Text("Detele"),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        if (user.uid == widget.snap['uid']) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              "You can't Report Your Post",
                                              style: TextStyle(),
                                            ),
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                              "Your Request Has Been Recorded\nThank you Making Auxilium Great !!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ));
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.0, horizontal: 16),
                                        child: Text("Report the Post"),
                                      ))
                                ],
                              ),
                            ));
                  },
                  icon: Icon(Icons.more_vert))
            ],
          ),
        ),
        //Post
        InkWell(
          onDoubleTap: () async {
            setState(() {
              _isliked = true;
            });
            await FirestoreMethods().likePost(
                widget.snap['postId'], user.uid, widget.snap['likes'], false);
          },
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.5,
            // width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.snap['postUrl'],
              filterQuality: FilterQuality.medium,
              fit: BoxFit.cover,
            ),
          ),
        ),
        //Like, Comment, Share and Save
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  await FirestoreMethods().likePost(widget.snap['postId'],
                      user.uid, widget.snap['likes'], true);
                  setState(() {
                    _isliked = !_isliked;
                    print("liked==>$_isliked");
                  });
                },
                child: Container(
                  height: 40,
                  width: 90,
                  child: Center(
                    child: _isliked
                        ? const Icon(
                            Icons.favorite,
                            color: lightGreenColor,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: darkGreenColor,
                          ),
                  ),
                  decoration: _isliked
                      ? BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(20))
                      : BoxDecoration(
                          color: greenColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  snap: widget.snap,
                                )));
                  },
                  icon: const Icon(CupertinoIcons.bubble_left)),
              const SizedBox(
                width: 10,
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Expanded(child: Container()),
              IconButton(onPressed: () {}, icon: Icon(Icons.archive_outlined))
            ],
          ),
        ),
        //description, number of likes and date
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w600),
                  child: Text("${widget.snap['likes'].length} likes")),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 10),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                      TextSpan(
                          text: "${widget.snap['username']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      TextSpan(
                          text: "  ${widget.snap['description']}",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14)),
                    ])),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(snap: widget.snap)));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "View all $commentlen comments",
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublish'].toDate()),
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

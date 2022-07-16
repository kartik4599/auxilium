import 'package:flutter/material.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:instagram_demo/widget/post_card.dart';

class SinglePost extends StatelessWidget {
  final snap;
  const SinglePost({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mobileBackground,
        title: Text("Post"),
      ),
      body: SingleChildScrollView(child: PostCard(snap: snap)),
    );
  }
}

// class SinglePost extends StatefulWidget {
//   final snap;
//   const SinglePost({Key? key, this.snap}) : super(key: key);

//   @override
//   State<SinglePost> createState() => _SinglePostState();
// }

// class _SinglePostState extends State<SinglePost> {
//   @override
//   Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     backgroundColor: mobileBackground,
    //     title: Text("Post"),
    //   ),
    //   body: SingleChildScrollView(child: PostCard(snap: widget.snap)),
    // );
  // }
// }

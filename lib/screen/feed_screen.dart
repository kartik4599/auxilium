import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_demo/widget/post_card.dart';
import 'package:loading_animations/loading_animations.dart';
import '../utils/color.dart';

class feedScreen extends StatelessWidget {
  const feedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("post")
            .orderBy('datePublish', descending: true)
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
            itemBuilder: ((context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                )),
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}

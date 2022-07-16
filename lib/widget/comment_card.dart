import 'package:flutter/material.dart';
import 'package:instagram_demo/models/user.dart';
import 'package:instagram_demo/resources/firestore_methods.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profImage']),
            radius: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.snap['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  TextSpan(text: "  ${widget.snap['text']}")
                ])),
                const Padding(padding: EdgeInsets.only(top: 4)),
                Text(
                    DateFormat.yMMMMd()
                        .format(widget.snap['datePublished'].toDate())
                        .toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400))
              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

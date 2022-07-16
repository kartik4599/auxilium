import 'package:flutter/material.dart';
import 'package:instagram_demo/utils/color.dart';

class AccountList extends StatelessWidget {
  final snap;
  const AccountList({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(snap['photoURL']),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snap['username'],
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkGreenColor),
              ),
              SizedBox(
                height: 20,
                child: Text(
                  snap['bio'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                ),
              )
            ],
          ),
          // Expanded(child: Container()),

          // SizedBox(
          //   width: 20,
          // )
        ],
      ),
    );
  }
}

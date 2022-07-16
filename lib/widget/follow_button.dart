import 'package:flutter/material.dart';
import '../utils/color.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key? key,
    required this.wid,
    required this.follow,
  }) : super(key: key);

  final double wid;
  final bool follow;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        height: 40,
        width: widget.wid / 3,
        decoration: BoxDecoration(
            color: widget.follow ? Colors.grey.shade700 : greenColor,
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: widget.follow
              ? Text(
                  "Unfollow",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )
              : Text(
                  "Follow",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}

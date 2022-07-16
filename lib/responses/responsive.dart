import 'package:flutter/material.dart';
import 'package:instagram_demo/provider/user_provider.dart';
import 'package:provider/provider.dart';

const webScreenSize = 600;

class ReponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget moblieScreenLayout;
  const ReponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.moblieScreenLayout})
      : super(key: key);

  @override
  State<ReponsiveLayout> createState() => _ReponsiveLayoutState();
}

class _ReponsiveLayoutState extends State<ReponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web Screen
          return widget.webScreenLayout;
        }
        //mobile Screen
        return widget.moblieScreenLayout;
      },
    );
  }
}

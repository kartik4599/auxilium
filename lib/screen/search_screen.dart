import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagram_demo/screen/profilr_screen.dart';
import 'package:loading_animations/loading_animations.dart';
import '../utils/color.dart';
import '../widget/account_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackground,
            title: TextFormField(
              decoration: InputDecoration(
                hintText: "Search of User",
                // border: InputBorder.none
              ),
              controller: _searchController,
              onFieldSubmitted: (String _) {
                setState(() {
                  print(_searchController.text);
                });
                setState(() {
                  _isSearch = true;
                });
                if (_searchController.text.isEmpty) {
                  setState(() {
                    _isSearch = false;
                  });
                }
              },
            )),
        body: _isSearch
            ? Future(searchController: _searchController)
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .orderBy('followers', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingBumpingLine.circle(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var snapshots = snapshot.data!.docs[index].data();
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: snapshots['uid'])));
                          },
                          child: AccountList(
                            snap: snapshots,
                          ),
                        );
                      });
                }));
  }
}

class Future extends StatelessWidget {
  const Future({
    Key? key,
    required TextEditingController searchController,
  })  : _searchController = searchController,
        super(key: key);

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .where('username', isGreaterThanOrEqualTo: _searchController.text)
            .get(),
        builder: (context, snapshot) {
          try {
            if (!snapshot.hasData) {
              return Center(
                child: LoadingBumpingLine.circle(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'])));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]
                                ['photoURL'])),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                      style: TextStyle(color: darkGreenColor),
                    ),
                    subtitle: Text(
                      (snapshot.data! as dynamic).docs[index]['bio'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          } catch (er) {
            print("object=>$er");
          }
          return LoadingBouncingLine.circle();
        });
  }
}

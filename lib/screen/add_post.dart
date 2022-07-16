import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_demo/models/user.dart';
import 'package:instagram_demo/provider/user_provider.dart';
import 'package:instagram_demo/resources/firestore_methods.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:instagram_demo/utils/utils.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  final TextEditingController _controller = TextEditingController();
  bool _isloading = false;

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose From Gallery"),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    try {
      setState(() {
        _isloading = true;
      });
      String res = await FirestoreMethods()
          .uploadPost(_controller.text, _file!, uid, username, profImage);
      if (res == "sucess") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Posted!",
            style: TextStyle(),
          ),
        ));
        setState(() {
          _isloading = false;
        });
        clearImage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            res,
            style: const TextStyle(),
          ),
        ));
        setState(() {
          _isloading = true;
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          err.toString(),
          style: const TextStyle(),
        ),
      ));
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackground,
              elevation: 0,
              title: Text(
                "Post to",
                style: TextStyle(
                  color: Colors.grey[300],
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
                child: IconButton(
              icon: const Icon(
                Icons.upload,
                color: darkGreenColor,
                size: 50,
              ),
              onPressed: () {
                _selectImage(context);
              },
            )),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackground,
              elevation: 0,
              title: Text(
                "Post to",
                style: TextStyle(
                  color: Colors.grey[300],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      postImage(user.uid, user.username, user.photoURl);
                    },
                    child: const Text(
                      "Post",
                      style: TextStyle(
                          color: darkGreenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Write a Caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter)),
                          )),
                    ),
                    // Divider()
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                _isloading
                    ? LoadingBumpingLine.circle(
                        backgroundColor: darkGreenColor,
                        size: 70,
                      )
                    : Container(),
              ],
            ));
  }
}

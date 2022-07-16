import 'dart:typed_data';
import 'package:instagram_demo/screen/login_page.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_demo/resources/auth_methods.dart';
import 'package:instagram_demo/utils/utils.dart';
import '../utils/color.dart';
import '../widget/text_filed.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUsers() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Hero(
                  tag: "title",
                  child: Image.asset(
                    "assets/Screenshot_2022-04-06_211208-removebg.png",
                    fit: BoxFit.cover,
                    width: 200,
                    // height: 20,
                  ),
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://yt3.ggpht.com/ytc/AKedOLSbkncl3asFI8nvP8iGSoz9mL_bhDfxd8BRNSVWuA=s176-c-k-c0x00ffffff-no-rj"),
                          ),
                    Positioned(
                        bottom: -9,
                        left: 80,
                        child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 25,
                            ))),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormInput(
                  textEditingController: _usernameController,
                  hintText: " username_321",
                  lableText: "Enter Username ",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormInput(
                  textEditingController: _emailController,
                  hintText: "abc@xyz.com",
                  lableText: "Enter email-id ",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormInput(
                  textEditingController: _passwordController,
                  hintText: "at least 6 charcters",
                  lableText: "Enter Password ",
                  obscure: true,
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormInput(
                  textEditingController: _bioController,
                  hintText: "Eg.Student",
                  lableText: "Enter your Bio",
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 70,
                ),
                InkWell(
                  onTap: signUpUsers,
                  // onTap: showSnackBar("Signup", context),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    child: _isloading
                        ? Center(
                            child: LoadingBumpingLine.circle(
                            size: 40,
                            backgroundColor: lightGreenColor,
                          ))
                        : const Center(
                            child: Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.lightGreen),
                          )),
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                // Expanded(child: Container()),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

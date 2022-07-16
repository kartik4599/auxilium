import 'package:flutter/material.dart';
import 'package:instagram_demo/resources/auth_methods.dart';
import 'package:instagram_demo/screen/sign_up_page.dart';
import 'package:instagram_demo/utils/color.dart';
import 'package:instagram_demo/widget/text_filed.dart';
import 'package:loading_animations/loading_animations.dart';
import '../responses/moblie_screen_layout.dart';
import '../responses/responsive.dart';
import '../responses/web_screen_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginUser() async {
    setState(() {
      _isLogin = true;
    });
    String res = await AuthMethod().loginuser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ReponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  moblieScreenLayout: MoblieScreenLayout())));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Login Falid",
          style: TextStyle(),
        ),
      ));
    }
    setState(() {
      _isLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > 800
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Hero(
                  tag: "title",
                  child: Image.asset(
                    "assets/Screenshot_2022-04-06_211208-removebg.png",
                    fit: BoxFit.contain,
                    width: 290,
                    // height: 300,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                TextFormInput(
                  textEditingController: _emailController,
                  hintText: "abc@xyz.com",
                  lableText: "Enter email-id ",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormInput(
                  textEditingController: _passwordController,
                  obscure: true,
                  hintText: "at least 6 charcters",
                  lableText: "Password",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: loginUser,
                  child: Container(
                    child: _isLogin
                        ? Center(
                            child: LoadingBumpingLine.circle(
                            backgroundColor: lightGreenColor,
                            size: 40,
                          ))
                        : const Center(
                            child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: lightGreenColor),
                          )),
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGreenColor),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

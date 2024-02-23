import 'package:admin/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../home/home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _checkbox = false;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      debugPrint('User signed in: ${userCredential.user!.uid}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided.');
      }
      // You can add more error handling here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: GoogleFonts.nunitoSans(textStyle:const TextStyle(fontWeight: FontWeight.bold) ),),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  "Welcome Back",
                  style: GoogleFonts.nunitoSans(textStyle:const TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
              ),
              const SizedBox(height: 10,),
              Text(
                  "Sign in with your email and password \n continue with social media",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(textStyle:const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey) )
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: GoogleFonts.nunitoSans(textStyle:const TextStyle() ),
                        hintText: 'Enter your email',
                        hintStyle: GoogleFonts.nunitoSans(textStyle:const TextStyle() ),
                        suffixIcon: const Icon(Iconsax.sms,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email';
                        }
                        // You can add more email validation here
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.nunitoSans(textStyle:const TextStyle() ),
                        hintText: 'Enter your password',
                        hintStyle: GoogleFonts.nunitoSans(textStyle:const TextStyle() ),
                        suffixIcon: const Icon(Iconsax.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more password validation here
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _checkbox,
                              onChanged: (value) {
                                setState(() {
                                  _checkbox = value!;
                                });
                              },
                            ),
                            Text(
                                'Remember me',
                                style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15))
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ForgotPassword(),
                            //   ),
                            // );
                          },
                          child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15))

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(

                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepOrange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _signInWithEmailAndPassword();
                    }
                  },
                  child: Text(
                      'SIGN IN',
                      style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold))
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/google-icon.svg",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/facebook-2.svg",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/icons/twitter.svg",
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child:Text(
                        'Sign Up',
                        style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

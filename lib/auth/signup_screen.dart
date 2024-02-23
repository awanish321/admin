
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../home/home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Register Account",
                style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              Text(
                "Complete your details or continue \nwith social media",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SignupForm(auth: _auth, firestore: _firestore),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const SignupForm({super.key, required this.auth, required this.firestore});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintText: 'Enter your first name',
                      suffixIcon: const Icon(Iconsax.user),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      labelText: 'Last Name',
                      hintText: 'Enter your last name',
                      suffixIcon: const Icon(Iconsax.user),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      suffixIcon: const Icon(Iconsax.user),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      suffixIcon: const Icon(Iconsax.call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _genderController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      labelText: 'Gender',
                      hintText: 'Enter your gender',
                      suffixIcon: const Icon(Iconsax.man),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: TextFormField(
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                      labelText: 'Date of Birth',
                      hintText: 'Enter your date of birth',
                      suffixIcon: const Icon(Iconsax.edit),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                labelText: 'E-mail',
                hintText: 'Enter your email',
                suffixIcon: const Icon(Iconsax.sms),
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
                return null;
              },
            ),

            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                labelText: 'Password',
                hintText: 'Enter your password',
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
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.nunitoSans(fontSize: 15),
                hintStyle: GoogleFonts.nunitoSans(fontSize: 15),
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
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
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 50,
              width: double.infinity,
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
                onPressed: _registerUser,
                child: Text(
                  'SIGN UP',
                  style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
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
                  "Already have an account!",
                  style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  },
                  child: Text(
                      'Sign In',
                      style: GoogleFonts.nunitoSans(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        final userCredential = await widget.auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the user ID
        final userId = userCredential.user!.uid;

        // Store user details in Firestore
        await widget.firestore
            .collection('users')
            .doc(userId) // Use user ID as document ID
            .set({
          'userId': userId,
          'email': _emailController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'username': _usernameController.text,
          'gender': _genderController.text,
          'dob': _dobController.text,
        });

        // Show a snackbar for registration success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User registered successfully'),
          ),
        );

        // Navigate to home screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(), // Your home screen widget
          ),
        );
      } catch (e) {
        // Show a snackbar for registration error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }


// void _registerUser() async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await widget.auth.createUserWithEmailAndPassword(
  //         email: _emailController.text,
  //         password: _passwordController.text,
  //       );
  //       await widget.firestore
  //           .collection('users')
  //           .doc(_emailController.text)
  //           .set({
  //         'email': _emailController.text,
  //         'firstName': _firstNameController.text,
  //         'lastName': _lastNameController.text,
  //         'phoneNumber': _phoneNumberController.text,
  //         'username': _usernameController.text,
  //         'gender': _genderController.text,
  //         'dob': _dobController.text,
  //       });
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('User registered successfully'),
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   }
  // }
}

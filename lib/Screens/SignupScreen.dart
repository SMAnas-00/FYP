import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _cniccontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _phonecontroller =
      TextEditingController(text: "+92");

  final _formkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void signup() async {
    await auth
        .createUserWithEmailAndPassword(
            email: _emailcontroller.text.toString(),
            password: _passwordcontroller.text.toString())
        .then((value) {
      auth.currentUser!.sendEmailVerification();
      final user = auth.currentUser;
      firestore
          .collection("app")
          .doc("Users")
          .collection("Signup")
          .doc(user!.uid)
          .set({
        'First_name': _namecontroller.text,
        'Last_name': _namecontroller.text,
        'Email': _emailcontroller.text,
        'Contact': _phonecontroller.text,
        'Password': _passwordcontroller.text,
        'Role': 'user',
        'Created_by': "user",
        'Active_lock': "1",
        'Modified_by': "user",
        'Modified_date': DateTime.now(),
        'Status': "Active",
        'id': user.uid,
      });
      _emailcontroller.clear();
      _passwordcontroller.clear();
      _namecontroller.clear();
      _phonecontroller.clear();
      Fluttertoast.showToast(msg: "Successfully Registered");
      Navigator.pushNamed(context, '/signin');
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Somthing wrong");
    });
  }

  bool _obsurePassText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffffffff),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          leading: IconButton(
              color: const Color(0xff212435),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ///***If you have exported images you must have to copy those images in assets/images directory.
                  const Image(
                    image: NetworkImage(
                        "https://cdn1.iconfinder.com/data/icons/borrow-book-flat/340/device_tablet_register_login_member_user-256.png"),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: Text(
                      "Let's Get Started!",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        color: Color(0xff3a57e8),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(
                      "Create an account and start exploring.",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: TextFormField(
                      controller: _namecontroller,
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Name";
                        }
                        if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Enter Correct Name";
                        }
                        return null;
                      },
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        hintText: "Name",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        prefixIcon: const Icon(Icons.person,
                            color: Color(0xff212435), size: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: TextFormField(
                      controller: _cniccontroller,
                      inputFormatters: [
                        CardFormatter(sample: 'xxxxx-xxxxxxx-x', separator: '-')
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter CNIC';
                        }
                        if (!RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]$')
                            .hasMatch(value)) {
                          return "Invalid CNIC ";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        hintText: "CNIC : xxxxx-xxxxxxx-x",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        prefixIcon: const Icon(Icons.add_card_rounded,
                            color: Color(0xff212435), size: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: TextFormField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Email";
                        }
                        if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$')
                            .hasMatch(value)) {
                          return 'Enter correct email';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        hintText: "Email Address",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        prefixIcon: const Icon(Icons.mail,
                            color: Color(0xff212435), size: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: TextField(
                      controller: _passwordcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obsurePassText,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obsurePassText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obsurePassText = !_obsurePassText;
                            });
                          },
                        ),
                        prefixIcon: const Icon(Icons.visibility,
                            color: Color(0xff212435), size: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: TextFormField(
                      controller: _phonecontroller,
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter phone number';
                        }
                        if (!RegExp(r'(^(?:[+0]9)?[0-9]{11}$)')
                            .hasMatch(value)) {
                          return "Enter correct number";
                        }
                        if (value.startsWith("0")) {
                          return "Please start with country code";
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                              color: Color(0xff3a57e8), width: 1),
                        ),
                        hintText: "+923041387752",
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: const Color(0xffffffff),
                        isDense: false,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        prefixIcon: const Icon(Icons.phone,
                            color: Color(0xff212435), size: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                    child: MaterialButton(
                      onPressed: () => signup(),
                      color: const Color(0xff3a57e8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xffffffff),
                      height: 45,
                      minWidth: MediaQuery.of(context).size.width,
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "By creating an account or continuing to use  a Palmer. you acknowledge and agree that you have accepted the Terms of  Services and  have reviewed the Privacy Policy.",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        color: Color(0xff807d7d),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Already have an account?",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: TextButton(
                              child: const Text(
                                "Sign In",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff3a57e8),
                                ),
                              ),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  signup();
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardFormatter extends TextInputFormatter {
  final String sample;
  final String separator;

  CardFormatter({
    required this.sample,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;
        if (newValue.text.length < sample.length &&
            sample[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

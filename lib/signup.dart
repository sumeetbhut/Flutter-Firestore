import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class SignupPage extends StatefulWidget {

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _textName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textAge = TextEditingController();
  final _textPassword = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text("Sign up", style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 20,),
                  Text("Create an account, It's free", style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700]
                  ),),
                ],
              ),
              Column(
                children: <Widget>[
                  makeInput(label: "Name",keyboardType:TextInputType.text,controller: _textName),
                  makeInput(label: "Email",keyboardType:TextInputType.emailAddress,controller: _textEmail),
                  makeInput(label: "Password",controller: _textPassword, obscureText: true),
                  makeInput(label: "Age",keyboardType:TextInputType.number,controller: _textAge),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 0, left: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  )
                ),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    _onPressed();
                  },
                  color: Colors.greenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: const Text("Sign up", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Already have an account?"),
                  Text(" Login", style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 18
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({label,keyboardType,controller,obscureText = false} ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
        ),),
        const SizedBox(height: 5,),
        TextField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: controller,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
            ),
          ),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }

  void _onPressed() async{
    var result = await firestoreInstance
        .collection("users")
        .where("email", isEqualTo:_textEmail.text)
        .get();

    if(result.size==0){
      firestoreInstance.collection("users").add(
          {
            "name" : _textName.text,
            "age" : int.parse(_textAge.text),
            "email" : _textEmail.text,
            "password" : _textPassword.text,
          }).then((value){
        print(value.id);
        setState(() {
          _textName.text="";
          _textAge.text="";
          _textEmail.text="";
          _textPassword.text="";
        });
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email already Register!"),
      ));
    }
  }
}
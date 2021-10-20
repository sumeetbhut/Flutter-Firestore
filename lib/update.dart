import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class UpdatePage extends StatefulWidget {

  final String userId;
  const UpdatePage._(this.userId) : super();

  static Route<String> route(String userId) {
    return MaterialPageRoute(builder: (_) => UpdatePage._(userId));
  }

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _textName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textAge = TextEditingController();
  final _textPassword = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Update',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.greenAccent,
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
                  makeInput(label: "Name",keyboardType:TextInputType.text,controller: _textName),
                  makeInput(label: "Email",keyboardType:TextInputType.emailAddress,controller: _textEmail),
                  makeInput(label: "Password",keyboardType:TextInputType.text,controller: _textPassword),
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
                  child: const Text("Update", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),),
                ),
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
    firestoreInstance.collection("users").doc(widget.userId).update(
        {
          "name" : _textName.text,
          "age" : int.parse(_textAge.text),
          "email" : _textEmail.text,
          "password" : _textPassword.text,
        }).then((value){
      print("success!");
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void getData() async {
    firestoreInstance.collection("users").doc(widget.userId).get().then((value) {
      setState(() {
        print(value.data());
        _textName.text=value['name'];
        _textEmail.text=value['email'];
        _textAge.text=value['age'].toString();
        _textPassword.text=value['password'];
      });
    });
  }
}
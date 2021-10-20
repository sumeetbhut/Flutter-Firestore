import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firestore_demo/main.dart';
import 'package:flutter_firestore_demo/update.dart';
import 'package:flutter_firestore_demo/user_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModel> userModels = [];

  UserModel? userModel;
  late DocumentReference<UserModel> reference;

  final firestoreInstance = FirebaseFirestore.instance;
  int? lessThan = 150;
  ScrollController? _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller!.addListener(_scrollListener);
    super.initState();
    //getData();
    getUpdateData();
  }

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller!.offset <= _controller!.position.minScrollExtent &&
        !_controller!.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {
                'Age less than 30',
                'Age less than 50',
                'Age less than 70',
                'Age less than 90',
                'Age less than 150'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: getListWidget(userModels!),
            ),
          ],
        ),
      ),
    );
  }

  void getData() async {
    userModels.clear();
    firestoreInstance
        .collection("users")
        .where('age', isLessThan: lessThan!)
        .get()
        .then((querySnapshot) {
      setState(() {
        querySnapshot.docs.forEach((result) {
          userModels.add(setData(result.id,result['name'],result['password'],result['email'],result['age']));
        });
      });
      print(userModels.length);
      /*querySnapshot.docs.forEach((result) {
        print(result['name']);
      });*/
    });
  }

  void getUpdateData() async {
    firestoreInstance.collection("users").snapshots().listen((result) {
      result.docChanges.forEach((res) {
        if (res.type == DocumentChangeType.added) {
          print("added");
          setState(() {
            if(userModels
                .indexWhere((element) => element.id == res.doc.id)==-1){
              userModels.add(setData(res.doc.id,res.doc.data()!['name'],res.doc.data()!['password'],res.doc.data()!['email'],res.doc.data()!['age']));
            }
          });
        } else if (res.type == DocumentChangeType.modified) {
          print("modified");
          setState(() {
            userModels[userModels!
                .indexWhere((element) => element.id == res.doc.id)] = setData(res.doc.id,res.doc.data()!['name'],res.doc.data()!['password'],res.doc.data()!['email'],res.doc.data()!['age']);
          });
        } else if (res.type == DocumentChangeType.removed) {
          print("removed");
          print(res.doc.data());
        }
      });
    });
  }

  UserModel setData(
      String id, String name, String password, String email, int age) {
    UserModel model = new UserModel();
    model.id = id;
    model.name = name;
    model.password = password;
    model.age = age;
    model.email = email;

    return model;
  }

  void handleClick(String value) {
    switch (value) {
      case 'Age less than 30':
        lessThan = 30;
        getData();
        break;
      case 'Age less than 50':
        lessThan = 50;
        getData();
        break;
      case 'Age less than 70':
        lessThan = 70;
        getData();
        break;
      case 'Age less than 90':
        lessThan = 90;
        getData();
        break;
      case 'Age less than 150':
        lessThan = 150;
        getData();
        break;
    }
  }

  Widget getListWidget(List<UserModel> _list) {
    if (_list.length == 0) return Container();
    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 80.0, left: 10.0),
      clipBehavior: Clip.antiAlias,
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        return getListViewItem(_list[index], index);
      },
    );
  }

  Widget getListViewItem(UserModel model, int position) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(UpdatePage.route(model.id!));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            SizedBox(
              width: 55,
              child: AspectRatio(
                aspectRatio: 0.88,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.name!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          maxLines: 2,
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      model.email!,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Age: ' + model.age.toString(),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 55,
              child: AspectRatio(
                aspectRatio: 0.88,
                child: GestureDetector(
                  onTap: () {
                    _onPressed(model.id!);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.delete),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed(String userId) {
    firestoreInstance.collection("users").doc(userId).delete().then((_) {
      getData();
    });
  }
}

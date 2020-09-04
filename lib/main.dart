import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cmd;
  var output = 'Output';
  //Map<String, String> all_output;
  var fsconnect = FirebaseFirestore.instance;

  //go to linux
  singleline(cmd) async {
    //print(image);
    //print(os);
    var url = 'http://192.168.1.10/cgi-bin/task2.py?x=$cmd';
    var r = await http.get(url);
    var display = r.body;
    fsconnect.collection("commands").add({
      'command': cmd,
      'output': display,
    });
    //print(r.body);
    setState(() {
      output = r.body;
      print(display);
    });
  }

  myget() async {
    var d = await fsconnect.collection("commands").get();
    //print(d.docs[0].id); //id returns the document id

    for (var i in d.docs) {
      print(i.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Linux Input n Output"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Input your linux command here :',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              onChanged: (value) => cmd = value,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                //hintText: 'Hint Text',
                //helperText: 'Helper Text',
                counterText: '0 characters',
                border: const OutlineInputBorder(),
              ),
            ),
            RaisedButton(
              onPressed: () {
                print("send the command to linux");
                singleline(cmd);
              },
              color: Colors.white,
              child:
                  Text("Send to Linux", style: TextStyle(color: Colors.black)),
            ),
            RaisedButton(
              onPressed: () {
                print("contact firestore and print output");
                myget();
              },
              color: Colors.white,
              child: Text("Firestore", style: TextStyle(color: Colors.black)),
            ),
            Text(
              output,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

//screen
import 'package:flutter_hive_demo/screens/newsPost.dart';
import 'package:flutter_hive_demo/screens/counter.dart';
import 'package:flutter_hive_demo/screens/clap_counter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
      routes: {
        '/': (context) => HomePage(),
        '/newsPost': (context) => NewsPost(),
        '/counter': (context) => Counter(),
        '/clapCounter': (context) => ClapCounter(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Wrap(
            spacing: 10,
            children: [
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/newsPost');
                },
                child: Text("News Post"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/counter');
                },
                child: Text("Counter"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/clapCounter');
                },
                child: Text("Clap Counter"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/newsPost');
                },
                child: Text("Driver Log"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/counter');
                },
                child: Text("Customer Log"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

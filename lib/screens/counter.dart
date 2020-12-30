import 'package:flutter/material.dart';
import 'package:flutter_hive_demo/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int task1Count = 0;
  int task2Count = 0;
  int task3Count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocalData();
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter1 = prefs.getInt(Config.taskCounter1);
    int counter2 = prefs.getInt(Config.taskCounter2);
    int counter3 = prefs.getInt(Config.taskCounter3);

    setState(() {
      task1Count = counter1 ?? 0;
      task2Count = counter2 ?? 0;
      task3Count = counter3 ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              RaisedButton(
                child: Text("Task 1 : Counter $task1Count"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int counter = (prefs.getInt(Config.taskCounter1) ?? 0) + 1;
                  await prefs.setInt(Config.taskCounter1, counter);
                  setState(() {
                    task1Count = counter;
                  });
                },
              ),
              RaisedButton(
                child: Text("Task 2 : Counter $task2Count"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int counter = (prefs.getInt(Config.taskCounter2) ?? 0) + 1;
                  if (counter <= 5) {
                    await prefs.setInt(Config.taskCounter2, counter);
                    setState(() {
                      task2Count = counter;
                    });
                  }
                },
              ),
              RaisedButton(
                child: Text("Task 3 : Counter $task3Count"),
                onPressed: () async {
                  SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  int counter = (prefs.getInt(Config.taskCounter3) ?? 0) + 1;
                  if (counter <= 25) {
                    await prefs.setInt(Config.taskCounter3, counter);
                    setState(() {
                      task3Count = counter;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

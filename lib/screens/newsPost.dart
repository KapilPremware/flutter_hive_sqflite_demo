import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hive_demo/model/api_data_class.dart';
import 'package:flutter_hive_demo/utility/database_helper.dart';
import 'package:flutter_hive_demo/utility/hive_helper.dart';
import 'package:flutter_hive_demo/widget/post_widget.dart';
import 'package:hive/hive.dart';

class NewsPost extends StatefulWidget {
  @override
  _NewsPostState createState() => _NewsPostState();
}

class _NewsPostState extends State<NewsPost> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  var rng = new Random();
  int userId = 0;
  bool isLoading = false;
  List dataList = [
    {
      "id": '1',
      "title": "Modi Bhao",
      "likeCount": 5,
      "totalLikeCount": 500,
      "share": 0,
      "img":
          "https://c.ndtvimg.com/2020-11/v6v4efno_pm-modi_625x300_20_November_20.jpg",
      "desc":
          "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": '2',
      "title": "Rahul Gandhi",
      "likeCount": 0,
      "totalLikeCount": 1,
      "share": 0,
      "img":
          "https://static.theprint.in/wp-content/uploads/2019/01/2019_1img02_Jan_2019_PTI1_2_2019_000222B-e1556766478652.jpg",
      "desc":
          "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": '3',
      "title": "Lalu Yadav",
      "likeCount": 0,
      "totalLikeCount": 20,
      "share": 0,
      "img":
          "https://akm-img-a-in.tosshub.com/sites/dailyo/story/embed/202011/main_lalu-prasad-yad_110320075017.jpg",
      "desc":
          "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": '4',
      "title": "mamta banerjee",
      "likeCount": 0,
      "totalLikeCount": 13,
      "share": 0,
      "img":
          "https://images.moneycontrol.com/static-mcnews/2019/05/mamata-banerjee-770x433-770x433.jpg",
      "desc":
          "this is description. this is description. this is description.this is description.this is description.",
    },
  ];

  List localDBList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userId = rng.nextInt(100);
    });
    print(userId);
  }

  /*void deleteData(String postId, String userId, int index){
    setState(() { isLoading = true; });
    String query = "DELETE FROM NewsPost WHERE postId = ? & userId = ?";
    List<dynamic> arguments = [postId,userId];
    Future<APIDataClass> res = databaseHelper.deleteRaw(query, arguments);
    res.then((data){
      setState(() { isLoading = false; });
      if(data.IsSuccess == true && data.Data == 1){
        print(data.Data);
        setState(() {
          dataList[index]['like'] = false;
        });
      } else {
        print(data.Message);
      }
    }, onError: (e){
      print("Error : On Profile Screen");
      //showMsg(" getData 2 : Server not working");
      setState(() { isLoading = false; });
    });
  }*/

  void updateData(int count, String postId, String userId, int index) {
    if (count <= 50) {
      setState(() {
        isLoading = true;
      });
      String query =
          "UPDATE NewsPost Set count = ? WHERE postId = ? & userId = ?";
      List<dynamic> arguments = [count, postId, userId];
      Future<APIDataClass> res = databaseHelper.updateRaw(query, arguments);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data.IsSuccess == true && data.Data == 1) {
          print(data.Data);
          setState(() {
            //remove previous counting
            dataList[index]['totalLikeCount'] -= dataList[index]['likeCount'];
            //set counting
            dataList[index]['likeCount'] = count;
            dataList[index]['totalLikeCount'] += count;
          });
        } else {
          print(data.Message);
        }
      }, onError: (e) {
        print("Error : On Profile Screen");
        //showMsg(" getData 2 : Server not working");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      print('max limit reached');
    }
  }

  void addData(String postId, String userId, int count, int index) {
    String query = "INSERT INTO NewsPost(postId,userId, count) VALUES(?,?,?)";
    List<dynamic> arguments = [postId, userId, count];
    Future<APIDataClass> res = databaseHelper.insertRaw(query, arguments);
    res.then((data) {
      setState(() {
        isLoading = false;
      });
      if (data.IsSuccess == true && data.Data == 1) {
        print(data.Data);
        setState(() {
          dataList[index]['likeCount'] += count;
          dataList[index]['totalLikeCount'] += count;
        });
      } else {
        print(data.Message);
      }
    }, onError: (e) {
      print("Error : On Profile Screen");
      //showMsg(" getData 2 : Server not working");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Post"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: dataList.length,
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return PostWidget(
                data: dataList[index],
                onLike: (){
                  if (dataList[index]['likeCount'] == 0)
                    addData(dataList[index]['id'],userId.toString(), 1, index);
                  else {
                    var count = dataList[index]['likeCount'] + 1;
                    updateData(count, dataList[index]['id'], userId.toString(), index);
                  }
                },
              );
            },
          ),
          if (isLoading)
            Center(
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(90),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(strokeWidth: 5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

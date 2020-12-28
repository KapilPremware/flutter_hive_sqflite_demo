import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hive_demo/utility/database_helper.dart';
import 'package:flutter_hive_demo/utility/hive_helper.dart';
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
      "id": 1,
      "title": "Modi Bhao",
      "like": false,
      "share": 0,
      "img":
      "https://c.ndtvimg.com/2020-11/v6v4efno_pm-modi_625x300_20_November_20.jpg",
      "desc":
      "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": 2,
      "title": "Rahul Gandhi",
      "like": false,
      "share": 0,
      "img":
      "https://static.theprint.in/wp-content/uploads/2019/01/2019_1img02_Jan_2019_PTI1_2_2019_000222B-e1556766478652.jpg",
      "desc":
      "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": 3,
      "title": "Lalu Yadav",
      "like": false,
      "share": 0,
      "img":
      "https://akm-img-a-in.tosshub.com/sites/dailyo/story/embed/202011/main_lalu-prasad-yad_110320075017.jpg",
      "desc":
      "this is description. this is description. this is description.this is description.this is description.",
    },
    {
      "id": 4,
      "title": "mamta banerjee",
      "like": false,
      "share": 0,
      "img":
      "https://images.moneycontrol.com/static-mcnews/2019/05/mamata-banerjee-770x433-770x433.jpg",
      "desc":
      "this is description. this is description. this is description.this is description.this is description.",
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userId = rng.nextInt(100);
    });
    print(userId);
  }

  void checkLike(String id) async {
    Box box = await databaseHelper.;
    if (box != null) {
      for (int i = 0; i < box.values.length; i++) {
        var element = box.getAt(i);
        if (element["id"].toString() == id && element["userId"].toString() == userId.toString()){
          print(element);
          print(i);
        }
      }
      var data = box.values.where((element) =>
      element["id"].toString() == id &&
          element["userId"].toString() == userId.toString());
      if (data != null) {
        print(data);
      }
    }

  }

  GetUerData(){
    setState(() { isLoading = true; });
    Future res = databaseHelper.getNewsPostMapList();
    res.then((data){
      setState(() { isLoading = false; });
      if(data != null && data.length > 0){

      }else{
        //showMsg("Data not found");
      }
    }, onError: (e){
      print("Error : On Profile Screen");
      //showMsg(" getData 2 : Server not working");
      setState(() { isLoading = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News Post"),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          "https://randomuser.me/api/portraits/men/36.jpg",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${dataList[index]['title']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.network("${dataList[index]['img']}"),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "${dataList[index]['desc']}",
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("0 Like"),
                              SizedBox(width: 20),
                              Text("0 Share"),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  dataList[index]['like']
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                ),
                                onPressed: () {
                                  print(dataList[index]['like']);
                                  setState(() {
                                    dataList[index]['like'] =
                                    !dataList[index]['like'];
                                  });
                                  print(dataList[index]['like']);
                                },
                              ),
                              SizedBox(width: 20),
                              Icon(Icons.share),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

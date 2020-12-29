import 'package:flutter/material.dart';
import 'package:flutter_hive_demo/model/api_data_class.dart';
import 'package:flutter_hive_demo/utility/database_helper.dart';
import 'package:flutter_hive_demo/networking/api.dart';

class CustomerLog extends StatefulWidget {
  @override
  _CustomerLogState createState() => _CustomerLogState();
}

class _CustomerLogState extends State<CustomerLog> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool isLoading = false;
  bool isUploadLoading = false;
  List dataList = [];
  int uploadProcessCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void addData() {
    String query = "insert into CustomerLog values(?,?,?,?,?,?,?)";
    List<dynamic> args = [
      "Bhatar",
      "Vesu",
      200,
      5,
      "2020-12-23T11:48:29.060+00:00",
      "5f7c382ccdb52d1969893598",
      "5f7c3868cdb52d1969893599"
    ];
    Future<APIDataClass> res = databaseHelper.insertRaw(query, args);
    res.then((data) {
      setState(() {
        isLoading = false;
      });
      if (data.IsSuccess == true && data.Data == 1) {
        print(data.Data);
        getData();
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

  void getData() {
    String query = "SELECT * FROM CustomerLog";
    Future<APIDataClass> res = databaseHelper.getDataRaw(query);
    res.then((data) {
      setState(() {
        isLoading = false;
      });
      if (data.IsSuccess == true) {
        print(data.Data);
        setState(() {
          dataList = data.Data;
        });
      } else {
        print(data.Message);
        setState(() {
          dataList = [];
        });
      }
    }, onError: (e) {
      print("Error : On Profile Screen");
      //showMsg(" getData 2 : Server not working");
      setState(() {
        isLoading = false;
      });
    });
  }

  void uploadLogToServer() {
    try {
      setState(() {
        isUploadLoading = true;
      });
      //Gating data from local DB
      String query = "SELECT * FROM CustomerLog";
      Future<APIDataClass> res = databaseHelper.getDataRaw(query);
      res.then((data) {
        if (data.IsSuccess == true && data.Data.length > 0) {
          setState(() {
            uploadProcessCount = 1;
          });
          var dataListFromLocal = data.Data;
          //Uploading to server
          Apis.postApi("addCustomerLogBulk", dataListFromLocal)
              .then((data) async {
            if (data.IsSuccess == true) {
              setState(() {
                uploadProcessCount = 2;
              });

              //Deleting from local DB
              String query = "delete from CustomerLog";
              Future<APIDataClass> deleteRes = databaseHelper.deleteRaw(query);
              deleteRes.then((value) {
                setState(() {
                  isUploadLoading = false;
                  dataList = [];
                });
                print('Data Uploaded Successfully!');
              }, onError: (e) {
                print("Error : $e");
                setState(() {
                  isUploadLoading = false;
                });
              });
            } else {
              setState(() {
                isUploadLoading = false;
              });
            }
            print(data.Data);
            print(data.Message);
          });
        } else {
          setState(() {
            isUploadLoading = false;
          });
          print(data.Message);
        }
      }, onError: (e) {
        print("Error : $e");
        setState(() {
          isUploadLoading = false;
        });
      });
    } on Exception catch (e) {
      setState(() {
        isUploadLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Log"),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              uploadLogToServer();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              addData();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: [
                    Text("${dataList[index]["pickAddress"]}"),
                    Text("${dataList[index]["dropAddress"]}"),
                    Text("${dataList[index]["totalAmount"]}"),
                    Text("${dataList[index]["totalWeight"]}"),
                    Text("${dataList[index]["dateTime"]}"),
                    Text("${dataList[index]["customerId"]}"),
                    Text("${dataList[index]["vehicleId"]}"),
                  ],
                ),
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
          if (isUploadLoading)
            Center(
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(90),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Row(
                      children: [
                        CircularProgressIndicator(strokeWidth: 5),
                        SizedBox(width: 20),
                        Text("${uploadProcessCount == 0 ? 'Gating data from local DB' : uploadProcessCount == 1 ? 'Uploading to server' : 'Deleting from local DB'}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

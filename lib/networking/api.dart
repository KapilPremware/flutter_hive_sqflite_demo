import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_hive_demo/config.dart';
import 'package:flutter_hive_demo/model/api_data_class.dart';

Dio dio = new Dio();

class Apis {
  //to get full path with paramiters
  static Future<String> getFullUrl(String apiName, List params) async {
    String _url = "";
    if (params.length > 0) {
      _url = apiName + "?";
      for (int i = 0; i < params.length; i++) {
        _url = _url + '${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) _url = _url + "&";
      }
    } else
      _url = apiName;

    String url = api_url + '$_url';

    return url;
  }

  static Future<APIDataClass> getApi(String apiName, List params) async {
    //default data to class
    APIDataClass apiData = new APIDataClass(
      Message: 'No Data',
      IsSuccess: false,
      Data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      apiData.Message = "No Internet Access";
      apiData.IsSuccess = false;
      apiData.Data = 0;
      return apiData;
    } else {
      String url = await getFullUrl(apiName, params);
      print("$apiName URL: " + url);

      try {
        //dio.options.headers["authtoken"] = authtoken;
        Response response = await dio.get(url);
        if (response.statusCode == 200) {
          //get response
          var responseData = response.data;
          print("$apiName Response: " + response.data.toString());

          //set data to class
          apiData.Message = responseData["Message"];
          apiData.IsSuccess = responseData["IsSuccess"];
          apiData.Data = responseData["Data"];
          return apiData;
        } else {
          apiData.Message = "No Internet Access";
          apiData.IsSuccess = false;
          apiData.Data = 0;
          return apiData;
        }
      } catch (e) {
        String message = e.toString();
        if (e.toString().contains("hostname")) message = "Server Error";
        apiData.Message = message;
        apiData.IsSuccess = false;
        apiData.Data = 0;

        return apiData;
      }
    }
  }

  static Future<APIDataClass> postApi(String apiName, body) async {
    //default data to class
    APIDataClass apiData = new APIDataClass(
      Message: 'No Data',
      IsSuccess: false,
      Data: '0',
    );
    //Check For Internet
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      apiData.Message = "No Internet Access";
      apiData.IsSuccess = false;
      apiData.Data = 0;
      return apiData;
    } else {
      String url = api_url + '$apiName';
      print("$apiName : " + url);

      try {
        //dio.options.headers["authtoken"] = authtoken;
        final response = await dio.post(url, data: body);
        if (response.statusCode == 200) {
          //get response
          var responseData = response.data;
          print("$apiName Response: " + response.data.toString());

          //set data to class
          apiData.Message = responseData["Message"];
          apiData.IsSuccess = responseData["IsSuccess"];
          apiData.Data = responseData["Data"];
          return apiData;
        } else {
          apiData.Message = "No Internet Access";
          apiData.IsSuccess = false;
          apiData.Data = 0;
          return apiData;
        }
      } catch (e) {
        String message = e.toString();
        if (e.toString().contains("hostname")) message = "Server Error";
        apiData.Message = message;
        apiData.IsSuccess = false;
        apiData.Data = 0;

        print(e.toString());

        return apiData;
      }
    }
  }
}
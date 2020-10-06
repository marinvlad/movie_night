import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_night/networking/AppException.dart';
import 'package:http/http.dart' as http;
import 'package:movie_night/view/screens/login_screen.dart';

class Commons {
  static const String imageBaseURL = "https://image.tmdb.org/t/p/w500/";
  static const backGroundColor = const Color.fromRGBO(73, 51, 144, 1);

  


  static Widget mnLoader() {
    return Center(child: SpinKitFoldingCube(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? Color(0xFFFFFFFF) : Color(0xFF311433),
          ),
        );
      },
    ));
  }

  static void showError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(message),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  static Widget mnLoading(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(18), child: Text(message)),
        mnLoader(),
      ],
    );
  }

  static Future logout(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  static dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
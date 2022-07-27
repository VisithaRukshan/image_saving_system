import 'dart:convert';
import 'package:image_saving_system/data_models/image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' as rootBundle;

class Api {
  var client = http.Client();
  String endPoint = 'http://192.168.1.5:8001/api/v1/image';

//get all images
  Future<List<Image>> getImageList() async {
    String _url = '$endPoint/get-all-images';

    var response = await client.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((e) => Image.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  //post images
  Future<String> postImages(String body) async {
    String _url = '$endPoint/save';

    var response = await client.post(
      Uri.parse(_url),
      body: body,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  //delete images
  Future<String> deleteImages(int id) async {
    String _url = '$endPoint/delete-image/$id';

    var response = await client.delete(Uri.parse(_url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }
}

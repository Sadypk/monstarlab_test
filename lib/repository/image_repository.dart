import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monstarlab_test/data/unsplash_image_model.dart';

class ImageRepository {
  String baseUrl = "https://api.unsplash.com/photos";
  String clientIdKey = "9DNtRc29wbjlQ76xr-XKqaecxoxzRwNPpENO7-HZ-cc";

  Map<String, String> headers = <String, String>{
    "content-type": "application/json"
  };

  Future<List<UnsplashImage>> get(int index) async {
    var response = await http.get(
      Uri.parse('$baseUrl?client_id=$clientIdKey&page=$index'),
    );
    List<UnsplashImage> list = <UnsplashImage>[];
    list = json.decode(response.body).map<UnsplashImage>((dynamic value)=> UnsplashImage.fromJson(value)).toList();
    return list;
  }
}

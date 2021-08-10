import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infinite_list/post/model/post.dart';

class PostApi {
  static String _domain = "jsonplaceholder.typicode.com";
  static String _path = "/posts";

  static Future<List<Post>> fetchPost(int start, int limit) async {
    final response = await http.get(
      Uri.https(
        _domain,
        _path,
        {"_start": "$start", "_limit": "$limit"},
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch post");
    }

    final json = jsonDecode(response.body) as List;
    return json
        .map<Post>(
          (post) => Post(
            id: post["id"],
            title: post["title"],
            body: post["body"],
            userId: post["userId"],
          ),
        )
        .toList();
  }
}

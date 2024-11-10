import 'package:http/http.dart' as http;
import 'dart:convert';
import 'repo_model.dart';

Future<List<Repo>> fetchRepos() async {
  final response =
      await http.get(Uri.parse('https://api.github.com/gists/public'));

  if (response.statusCode == 200) {
    final List<dynamic> reposJson = jsonDecode(response.body);
    return reposJson.map((json) => Repo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load repositories');
  }
}

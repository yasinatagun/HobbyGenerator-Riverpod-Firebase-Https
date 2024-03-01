import 'dart:convert';
import 'package:hobby_generator/data/api_keys.dart';
import 'package:http/http.dart' as http;
import '../models/hobby.dart';

class HobbyService {
  final baseUrl = 'https://api.api-ninjas.com/v1/hobbies';

  Future<Hobby> fetchHobby(String category) async {
    final url = Uri.parse('$baseUrl?category=$category');
    final response = await http.get(url, headers: {
      'X-Api-Key': ApiKeys.hobbyApiKey,
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Hobby.fromJson(body); 
    } else {
      throw Exception('Failed to load hobby');
    }
  }
}

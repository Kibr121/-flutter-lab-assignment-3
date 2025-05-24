import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
  });

  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      print('Making request to: $uri'); // Debug log
      
      final response = await client.get(uri);
      print('Response status code: ${response.statusCode}'); // Debug log
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data'); // Debug log
        return data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      print('JSON parsing error: $e'); // Debug log
      throw Exception('Invalid response format: $e');
    } on http.ClientException catch (e) {
      print('Network error: $e'); // Debug log
      throw Exception('Network error: $e');
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
      throw Exception('Failed to connect to the server: $e');
    }
  }
} 


import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslateApi {
  final String apiKey; 

  TranslateApi({required this.apiKey});

  // Çeviri işlevi
  Future<String> translateText(String text, String targetLanguage) async {
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$apiKey');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'target': targetLanguage,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Failed to translate text');
    }
  }
}




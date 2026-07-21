import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _apiKey = 'TU_API_KEY_AQUI';
  static const String _url = 'https://api.openai.com/v1/chat/completions';

  static Future<String> generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'content': 'Eres un novelista profesional y mentor de escritura creativa. Tu trabajo es ayudar a escritores a desarrollar sus ideas. Se creativo, inspirador y detallado. Cuando te pidan crear un personaje, describe su apariencia, personalidad, historia y motivaciones. Cuando te pidan un mundo, describe la ambientacion, reglas, cultura y conflictos. Cuando te pidan un capitulo, escribe narrativa real con dialogo y descripcion. Siempre responde en espanol con un tono profesional pero cercano. Minimo 150 palabras por respuesta.',
            },
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 800,
          'temperature': 1.0,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexion';
    }
  }
}
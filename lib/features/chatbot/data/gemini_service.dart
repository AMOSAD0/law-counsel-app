import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = 'AIzaSyC_NryW8YAEAtC_ymyCuC7_mOCR6vfVzD8';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey';
     

  static Future<String> sendMessage(String prompt) async {
    final systemPrompt = '''
أنت محامي مصري ذكي، وظيفتك تساعد المستخدم يفهم قضيته أو مشكلته القانونية بطريقة مبسطة.

لما المستخدم يحكي لك مشكلته:
- حدد نوع القضية (زي: جنائي، مدني، أحوال شخصية، قضايا عمل...)
- قوله إذا كان محتاج محامي ولا لا
- قوله محتاج يحضر أي ورق أو مستندات
- لو ينفع، اقترح خطوات عامة ممكن يبدأ بيها

مهم:
- لا تستخدم مصطلحات قانونية معقدة
- خلي إجابتك مفهومة لأي شخص عادي
- متقولش استشارات قانونية دقيقة، بس معلومات عامة

المشكلة: $prompt
''';
    try {
      final res = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": systemPrompt},
              ],
            },
          ],
        }),
      );

      final data = jsonDecode(res.body);
      print(res.body);

      return data['candidates'][0]['content']['parts'][0]['text'] ??
          'No response.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploadHelper {
  static Future<String?> uploadImageToKit(File imagefile) async {
    try {
      final bytes = await imagefile.readAsBytes();
      final base64 = base64Encode(bytes);

      const String apiUrl = 'https://upload.imagekit.io/api/v1/files/upload';
      const String publicKey = 'public_cbOmju4WCHp9iDSE0cBirVas8Gs=';
      const String privateApiKey = 'private_BqNxYrUStZ2SoYkMmbgr+Tqy8JI=';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$privateApiKey:'))}',
        },
        body: {
          'file': 'data:image/jpeg;base64,$base64',
          'fileName': 'post_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'publicKey': publicKey,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['url'];
      } else {
        print('Upload failed: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception during image upload: $e');
      return null;
    }
  }
}

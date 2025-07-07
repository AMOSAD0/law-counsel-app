// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class ImageUploadHelper {
//   static Future<String?> uploadImage(XFile image) async {
//     try {
//       final uri = Uri.parse('https://upload.imagekit.io/api/v1/files/upload');
//       final request = http.MultipartRequest('POST', uri)
//         ..headers['Authorization'] = 'Basic YOUR_ENCODED_PRIVATE_KEY'
//         ..files.add(await http.MultipartFile.fromPath('file', image.path))
//         ..fields['fileName'] = 'upload_${DateTime.now().millisecondsSinceEpoch}';

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final res = await http.Response.fromStream(response);
//         final data = json.decode(res.body);
//         return data['url'];
//       } else {
//         print("Upload failed: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class ImageUploadHelper {
  static Future<String?> uploadImageToKit(File? imagefile) async {
    final bytes = await imagefile!.readAsBytes();
    final Base64 = base64Encode(bytes);
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
        'file': 'data:image/jpeg;base64,$Base64',
        'fileName': 'post_${DateTime.now().millisecondsSinceEpoch}.jpg',
        'publicKey': publicKey,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['url'];
    } else {
      print(' Upload failed: ${response.statusCode}');
      print(' Body: ${response.body}');
      return null;
    }
  }
  }

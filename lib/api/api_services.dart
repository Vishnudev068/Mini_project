import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  static String url = "http://192.168.1.3:8000/";

  static searchStore(Map<String, dynamic> data) async {
    String name = data["name"] ?? "";

    final uri = Uri.parse("${url}pharmacy/search/?name=$name");
    print(" value:$name");

    try {
      final res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);
        return data;
      }
    } catch (e) {}
  }

  static Future<bool> login(Map<String, dynamic> edata) async {
    String jsonData = jsonEncode(edata);
    try {
      final res = await http.post(
        Uri.parse(url + 'login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonData,
      );

      if (res.statusCode == 200) {
        print('Login Successful: ${res.body}');
        return true;
      } else {
        print('Login Failed: ${res.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
}

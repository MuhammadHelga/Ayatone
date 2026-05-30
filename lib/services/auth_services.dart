import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'api_config.dart';

class AuthServices {
  Future<Map<String, dynamic>?> getSurah() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getSurah));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAyat(String surahNumber) async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getAyat.replaceAll('{surah_number}', surahNumber)));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getAudio(String surahNumber) async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.getAudio.replaceAll('{surah_number}', surahNumber)));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data');
    }
    return null;
  }
}
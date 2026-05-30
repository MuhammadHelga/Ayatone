class ApiConfig {
  static String baseUrl = 'https://api.alquran.cloud/v1';
  static String audioBaseUrl = 'https://cdn.islamic.network/quran/audio-surah';

  static String getSurah = '$baseUrl/surah';
  static String getAyat = '$baseUrl/surah/{surah_number}/ayat';
  static String getAudio = '$audioBaseUrl/{bitrate}/{edition}/{number}.mp3';
}
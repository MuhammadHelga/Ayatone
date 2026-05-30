import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_config.dart';
import 'home_page_controller.dart';

class QariModel {
  final String name;
  final String id;

  const QariModel({required this.name, required this.id});
}

class PlayScreenController extends GetxController {
  static const String _qariKey = 'selected_qari_id';

  final AudioPlayer _audioPlayer = AudioPlayer();
  final HomePageController _homeController = Get.put(HomePageController());

  final List<QariModel> listQari = const [
    QariModel(name: 'Mishary Rashid Alafasy', id: 'ar.alafasy'),
    QariModel(name: 'Sudais & Shuraim', id: 'ar.sudaisshuraymnaeemsultan'),
    QariModel(name: 'Ahmed Al-Ajmi', id: 'ar.ahmedalajmi'),
    QariModel(name: 'Muhammad Ayyub', id: 'ar.muhammadayyub'),
    QariModel(name: 'Abdul Basit (Murattal)', id: 'ar.abdulbasitmurattal'),
    QariModel(name: 'Yasser Ad-Dussary', id: 'ar.yasseraldossari'),
  ];

  late final Rx<QariModel> selectedQari = Rx<QariModel>(listQari[0]);

  bool _isChangingSurah = false;
  var playingSurahNumber = 0.obs;
  var isAudioPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    _loadQari();

    _audioPlayer.onPlayerComplete.listen((event) async {
      if (_isChangingSurah) {
        debugPrint(
          'onPlayerComplete: Mengabaikan pemicuan selama perubahan surah sedang berlangsung.',
        );
        return;
      }

      debugPrint(
        'onPlayerComplete dipicu! Surah aktif: ${playingSurahNumber.value}, Jumlah listSurah: ${listSurah.length}',
      );

      if (listSurah.isEmpty || playingSurahNumber.value == 0) {
        debugPrint(
          'onPlayerComplete: Gagal lanjut karena listSurah kosong atau playingSurahNumber = 0',
        );
        playingSurahNumber(0);
        isAudioPlaying(false);
        duration.value = Duration.zero;
        position.value = Duration.zero;
        return;
      }

      int currentIndex = listSurah.indexWhere(
        (s) => s['number'] == playingSurahNumber.value,
      );

      debugPrint('onPlayerComplete: currentIndex = $currentIndex');

      if (currentIndex != -1 && currentIndex < listSurah.length - 1) {
        int nextSurahNumber = listSurah[currentIndex + 1]['number'];
        debugPrint(
          'onPlayerComplete: Mencoba memutar surah selanjutnya ke-$nextSurahNumber',
        );
        _isChangingSurah = true;
        try {
          await playSurahDirectly(nextSurahNumber);
        } catch (e) {
          debugPrint(
            'onPlayerComplete: Error saat memutar surah berikutnya: $e',
          );
        } finally {
          _isChangingSurah = false;
        }
      } else {
        debugPrint(
          'onPlayerComplete: Ini adalah surah terakhir atau tidak ditemukan',
        );
        isAudioPlaying(false);
        position.value = Duration.zero;
        Get.snackbar(
          'Info',
          'Semua surah selesai diputar',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    });

    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });
    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });
  }

  Future<void> _loadQari() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getString(_qariKey);
      if (savedId != null) {
        final qari = listQari.firstWhereOrNull((q) => q.id == savedId);
        if (qari != null) {
          selectedQari.value = qari;
        }
      }
    } catch (e) {
      Get.log('Error loading Qari: $e');
    }
  }

  Future<void> changeQari(QariModel qari) async {
    selectedQari.value = qari;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_qariKey, qari.id);
    } catch (e) {
      Get.log('Error saving Qari: $e');
    }

    if (playingSurahNumber.value != 0) {
      await playSurahDirectly(playingSurahNumber.value);
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> stopSurah() async {
    try {
      await _audioPlayer.stop();
      playingSurahNumber(0);
      isAudioPlaying(false);
      duration.value = Duration.zero;
      position.value = Duration.zero;
    } catch (e) {
      Get.log('Error stopping audio: $e');
    }
  }

  List<dynamic> get listSurah => _homeController.listSurah;

  dynamic get currentPlayingSurah {
    if (playingSurahNumber.value == 0 || listSurah.isEmpty) return null;
    return listSurah.firstWhereOrNull(
      (s) => s['number'] == playingSurahNumber.value,
    );
  }

  Future<void> seek(Duration pos) async {
    await _audioPlayer.seek(pos);
  }

  Future<void> playSurahDirectly(int surahNumber) async {
    try {
      await _audioPlayer.stop();
      duration.value = Duration.zero;
      position.value = Duration.zero;

      playingSurahNumber(surahNumber);
      isAudioPlaying(true);

      String audioUrl = ApiConfig.getAudio
          .replaceAll('{bitrate}', '128')
          .replaceAll('{edition}', selectedQari.value.id)
          .replaceAll('{number}', surahNumber.toString());

      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      Get.snackbar('Error', 'Gagal memutar audio: $e');
      playingSurahNumber(0);
      isAudioPlaying(false);
    }
  }

  Future<void> playNextSurah() async {
    if (listSurah.isEmpty || playingSurahNumber.value == 0) return;
    int currentIndex = listSurah.indexWhere(
      (s) => s['number'] == playingSurahNumber.value,
    );
    if (currentIndex != -1 && currentIndex < listSurah.length - 1) {
      int nextSurahNumber = listSurah[currentIndex + 1]['number'];
      await playSurahDirectly(nextSurahNumber);
    } else {
      Get.snackbar('Info', 'Ini adalah surah terakhir');
    }
  }

  Future<void> playPreviousSurah() async {
    if (listSurah.isEmpty || playingSurahNumber.value == 0) return;
    int currentIndex = listSurah.indexWhere(
      (s) => s['number'] == playingSurahNumber.value,
    );
    if (currentIndex > 0) {
      int prevSurahNumber = listSurah[currentIndex - 1]['number'];
      await playSurahDirectly(prevSurahNumber);
    } else {
      Get.snackbar('Info', 'Ini adalah surah pertama');
    }
  }

  Future<void> togglePlaySurah(int surahNumber) async {
    if (playingSurahNumber.value == surahNumber) {
      if (isAudioPlaying.value) {
        await _audioPlayer.pause();
        isAudioPlaying(false);
      } else {
        if (position.value == Duration.zero) {
          await playSurahDirectly(surahNumber);
        } else {
          await _audioPlayer.resume();
          isAudioPlaying(true);
        }
      }
    } else {
      await playSurahDirectly(surahNumber);
    }
  }
}

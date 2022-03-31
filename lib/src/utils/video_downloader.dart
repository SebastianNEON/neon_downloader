import 'dart:io';
import 'package:dio/dio.dart';
import 'package:neon_downloader/src/data/downloader.dart';
import 'package:neon_downloader/src/domain/entitys/video_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

Future<void> videoDownloader(
  String id,
  String url,
  void Function(int, int)? onProgress,
) async {
  late Directory videoDir;

  File? _file;

  bool _success = true;

  final cancelToken = CancelToken();

  final api = Downloader();

  VideoEntity _videoObj;

  SharedPreferences _prefs = await SharedPreferences.getInstance();

  final String? _videoId = _prefs.getString(id);

  try {
    if (Platform.isIOS) {
      videoDir = await getLibraryDirectory();
    } else if (Platform.isAndroid) {
      videoDir = await getApplicationDocumentsDirectory();
    }
    final videosDirectory = Directory(videoDir.path);

    if (!videosDirectory.existsSync()) {
      await videosDirectory.create();
    }

    String _buildFileName(Headers responseHeaders) {
      String fileType = responseHeaders['content-type']!.first.split('/').last;
      String filePath = '${videoDir.path}$id.$fileType';
      _file = File(filePath);
      return filePath;
    }

    await api.download(url, _buildFileName, onProgress, cancelToken);
  } on DioError catch (error) {
    _success = false;
    throw (error.response?.data);
  }
  if (_success && _file != null && _videoId != null) {
    _videoObj = VideoEntity.fromJson(_videoId);
    _videoObj = _videoObj.copyWith(vidioPath: _file!.path);
  }
}

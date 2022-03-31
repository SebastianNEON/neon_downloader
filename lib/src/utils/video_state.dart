import 'dart:convert';

import 'package:neon_downloader/src/domain/entitys/config_entity.dart';
import 'package:neon_downloader/src/domain/entitys/video_entity.dart';
import 'package:neon_downloader/src/data/get_video_file.dart';
import 'package:neon_downloader/src/utils/video_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _offlineVideoId = 'NEON_downloader_allOfflineVideoIds';
const String _confgId = 'NEON_downloader_config';

late SharedPreferences _prefs;

_getPrefs() async {
  _prefs = await SharedPreferences.getInstance();
}

Future<void> setupConfig({Duration? duration}) async {
  ConfigEntity _configEntity;
  await _getPrefs();

  _configEntity = ConfigEntity(duration: duration ?? const Duration(days: 30));

  await _prefs.setString(_confgId, jsonEncode(_configEntity.toJson()));
}

class VideoState {
  /// returns the [VideoEntity] object where you can access all relevant data
  /// if there is no object a new object will be created
  Future<VideoEntity> getVideoById({
    required String id,
    String? videoUrl,
    String? imgUrl,
  }) async {
    VideoEntity _videoObj;

    ConfigEntity _configEntity;

    await _getPrefs();

    String? _videoId = _prefs.getString(id);

    List<String>? items = _prefs.getStringList(_offlineVideoId);

    if (_videoId == null) {
      String? _config = _prefs.getString(_confgId);

      _configEntity = ConfigEntity.fromJson(_config);

      _videoObj = VideoEntity(
        id: id,
        videoUrl: videoUrl,
        imgUrl: imgUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deleteAt: DateTime.now().add(_configEntity.duration),
        lastPosition: const Duration(seconds: 0),
      );

      await _prefs.setString(id, jsonEncode(_videoObj.toJson()));

      if (items != null) {
        items.add(id);
        await _prefs.setStringList(_offlineVideoId, items);
      } else {
        await _prefs.setStringList(_offlineVideoId, [id]);
      }
    } else {
      _videoObj = VideoEntity.fromJson(_videoId);
      _videoObj = _videoObj.copyWith(updatedAt: DateTime.now());
    }

    return _videoObj;
  }

  Future<void> downloadVideoById({
    // video id
    required String id,

    // video download url
    required String videoUrl,

    // get download progress
    void Function(int, int)? onProgress,

    // date when the video should be deleted
    DateTime? deletTime,

    // img url - for thumpmail
    String? imgUrl,
  }) async {
    VideoEntity _videoObj;

    ConfigEntity _configEntity;

    await _getPrefs();

    String? _config = _prefs.getString(_confgId);

    _configEntity = ConfigEntity.fromJson(_config);

    String? _videoId = _prefs.getString(id);

    if (_videoId != null) {
      _videoObj = VideoEntity.fromJson(_videoId);
      if (_videoObj.vidioPath == null) {
        videoDownloader(id, videoUrl, onProgress);
      }
    } else {
      _videoObj = VideoEntity(
        id: id,
        videoUrl: videoUrl,
        imgUrl: imgUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deleteAt: deletTime ?? DateTime.now().add(_configEntity.duration),
        lastPosition: const Duration(seconds: 0),
      );

      await _prefs.setString(id, jsonEncode(_videoObj.toJson()));

      videoDownloader(id, videoUrl, onProgress);
    }
  }

  /// Checks whether the downloaded videos should be deleted
  ///
  /// case: [deleteAt] is after [DateTime.now]
  Future<void> checkVideoState() async {
    VideoEntity? _videoObj;

    await _getPrefs();

    List<String>? items = _prefs.getStringList(_offlineVideoId);

    if (items != null) {
      for (var i in items) {
        String? _videoId = _prefs.getString(i);

        if (_videoId != null) {
          _videoObj = VideoEntity.fromJson(_videoId);

          if (_videoObj.deleteAt != null) {
            if (_videoObj.deleteAt!.isAfter(DateTime.now())) {
              if ((await getVideoFile(_videoObj.vidioPath!)).existsSync()) {
                (await getVideoFile(_videoObj.vidioPath!)).deleteSync();

                items.remove(i);
                await _prefs.setStringList(_offlineVideoId, items);
                await _prefs.remove(i);
              }
            }
          }
        }
      }
    }
  }

  Future<void> updateProgressById(
    // video id
    String id,

    // current video progress
    Duration duration,
  ) async {
    VideoEntity _videoObj;

    await _getPrefs();

    String? _videoId = _prefs.getString(id);

    if (_videoId != null) {
      _videoObj = VideoEntity.fromJson(_videoId);
      _videoObj =
          _videoObj.copyWith(updatedAt: DateTime.now(), lastPosition: duration);
      await _prefs.setString(id, jsonEncode(_videoObj.toJson()));
    }
  }

  Future<void> updateDeletDateById(String id, DateTime date) async {
    VideoEntity _videoObj;

    await _getPrefs();

    String? _videoId = _prefs.getString(id);

    if (_videoId != null) {
      _videoObj = VideoEntity.fromJson(_videoId);
      _videoObj = _videoObj.copyWith(deleteAt: date);
      await _prefs.setString(id, jsonEncode(_videoObj.toJson()));
    }
  }

  Future<void> updateDeletDateByListOfIds(
      List<String> ids, DateTime date) async {
    VideoEntity _videoObj;

    await _getPrefs();

    for (var id in ids) {
      String? _videoId = _prefs.getString(id);
      if (_videoId != null) {
        _videoObj = VideoEntity.fromJson(_videoId);
        _videoObj = _videoObj.copyWith(deleteAt: date);
        await _prefs.setString(id, jsonEncode(_videoObj.toJson()));
      }
    }
  }

  // Remove/Delete video by id
  Future<void> removeById(String id) async {
    VideoEntity _videoObj;
    await _getPrefs();

    List<String>? items = _prefs.getStringList(_offlineVideoId);

    if (items != null && items.contains(id)) {
      String? _videoId = _prefs.getString(id);

      if (_videoId != null) {
        _videoObj = VideoEntity.fromJson(_videoId);

        if (_videoObj.vidioPath != null) {
          if ((await getVideoFile(_videoObj.vidioPath!)).existsSync()) {
            (await getVideoFile(_videoObj.vidioPath!)).deleteSync();
          }
        }

        items.remove(id);
        await _prefs.setStringList(_offlineVideoId, items);
        await _prefs.remove(id);
      }
    }
  }

  // Remove/Delete List of videos
  Future<void> removeByListOfIds(List<String> ids) async {
    VideoEntity _videoObj;
    await _getPrefs();

    List<String>? items = _prefs.getStringList(_offlineVideoId);

    for (var id in ids) {
      String? _videoId = _prefs.getString(id);
      if (items != null && _videoId != null) {
        _videoObj = VideoEntity.fromJson(_videoId);

        if (_videoObj.vidioPath != null) {
          if ((await getVideoFile(_videoObj.vidioPath!)).existsSync()) {
            (await getVideoFile(_videoObj.vidioPath!)).deleteSync();
          }
        }

        items.remove(id);
        await _prefs.setStringList(_offlineVideoId, items);
        await _prefs.remove(id);
      }
    }
  }

// Remove/Delete all videos
  Future<void> removeAll() async {
    VideoEntity _videoObj;

    await _getPrefs();

    List<String>? items = _prefs.getStringList(_offlineVideoId);

    if (items != null) {
      for (var i in items) {
        String? _videoId = _prefs.getString(i);

        if (_videoId != null) {
          _videoObj = VideoEntity.fromJson(_videoId);

          if (_videoObj.vidioPath != null) {
            if ((await getVideoFile(_videoObj.vidioPath!)).existsSync()) {
              (await getVideoFile(_videoObj.vidioPath!)).deleteSync();
            }
          }

          items.remove(i);
          await _prefs.remove(_offlineVideoId);
          await _prefs.remove(i);
        }
      }
    }
  }
}

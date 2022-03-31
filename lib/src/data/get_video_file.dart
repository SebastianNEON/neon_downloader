import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getVideoFile(String path, {String? id}) async {
  if (Platform.isAndroid) {
    if (id != null) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      return File('$directory$id.mp4');
    } else {
      return File(path);
    }
  }

  if (Platform.isIOS) {
    final directory = (await getLibraryDirectory()).path;
    if (id != null) {
      return File('$directory$id.mp4');
    } else {
      List splitPath = path.split('/');
      return File('$directory/videos/${splitPath.last}');
    }
  } else {
    throw PlatformException(
      code: 'Platform',
      message: 'Platform not supported',
    );
  }
}

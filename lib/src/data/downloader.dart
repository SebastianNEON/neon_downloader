import 'package:dio/dio.dart';

class Downloader {
  final dio = Dio();

  Future<dynamic> download(
    url,
    path,
    void Function(int, int)? onProgress,
    CancelToken cancelToken,
  ) async {
    return await dio.download(
      url,
      path,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );
  }
}

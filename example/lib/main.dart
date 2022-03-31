import 'package:flutter/material.dart';
import 'package:neon_downloader/neon_downloader.dart';

void main() {
  runApp(const MyApp());
}

const String id = 'video1';

const String testUrl =
    'https://multiplatform-f.akamaihd.net/i/multi/will/bunny/big_buck_bunny_,640x360_400,640x360_700,640x360_1000,950x540_1500,.f4v.csmil/master.m3u8';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Neon download test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoEntity text = const VideoEntity(id: '...');

  @override
  void initState() {
    super.initState();
    setupConfig(duration: const Duration(days: 30));
  }

  _getVideo() async {
    await VideoState()
        .getVideoById(id: 'videoId:1', videoUrl: 'kdsjhg iuer')
        .then((value) => setState((() => text = value)));
  }

  _updateVideo() async {
    await VideoState()
        .updateProgressById('videoId:1', const Duration(seconds: 15));
  }

  _removeVideo() async {
    await VideoState().removeById('videoId:1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
              child: MaterialButton(
            onPressed: () => _getVideo(),
            child: const Text('Button'),
          )),
          Center(
              child: MaterialButton(
            onPressed: () => _updateVideo(),
            child: const Text('update'),
          )),
          Center(
              child: MaterialButton(
            onPressed: () => _removeVideo(),
            child: const Text('remove'),
          )),
          Text(text.id ?? ''),
          Text(text.videoUrl ?? ''),
          Text(text.vidioPath ?? ''),
          Text(text.lastPosition.toString()),
          Text(text.createdAt.toString()),
          Text(text.updatedAt.toString()),
          Text(text.deleteAt.toString()),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

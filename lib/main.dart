import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  File? image;
  File? video;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      await GallerySaver.saveImage(image.path);
      print('Image Path: ${image.path}');
    }on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  // Future pickVideo(ImageSource source) async {
  //   try {
  //     final video = await ImagePicker().pickVideo(source: source);
  //     if (video == null) return;
  //
  //     final videoTemporary = File(video.path);
  //     setState(() => this.video = videoTemporary);
  //     await GallerySaver.saveImage(video.path);
  //     print('Video Path: ${video.path}');
  //   }on PlatformException catch(e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  Future pickVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) return;

      final videoTemporary = File(video.path);
      setState(() => this.video = videoTemporary);
      await GallerySaver.saveVideo(video.path);
      print('Video Path: ${video.path}');
    } on PlatformException catch (e) {
      print('Failed to pick video: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            video != null
                ? VideoPlayerWidget(videoPath: video!.path)
                : Container(
              width: 160,
              height: 160,
              color: Colors.grey,
            ),
            // image != null
            //     ? Image.file(
            //       image!,
            //       width:160,
            //       height:160,
            //       fit: BoxFit.cover,
            //     )
            //   : FlutterLogo(size: 160),
            // buildButton(
            //     title: 'Pick Gallery',
            //     icon: Icons.image_outlined,
            //     onClicked: ()=>pickImage(ImageSource.gallery),
            // ),
            // const SizedBox(height:24),
            // buildButton(
            //     title: 'Pick Camera',
            //     icon: Icons.camera_alt_outlined,
            //     onClicked: ()=>pickImage(ImageSource.camera),
            // ),
            const SizedBox(height:24),
            buildButton(
              title: 'Upload Video',
              icon: Icons.image_outlined,
              onClicked: ()=>pickVideo(ImageSource.gallery),
            ),
            const SizedBox(height:24),
            buildButton(
              title: 'Take Video',
              icon: Icons.camera_alt_outlined,
              onClicked: ()=>pickVideo(ImageSource.camera),
            )
          ],

        ),
      ),
    );
  }
}

Widget buildButton({
  required String title,
  required IconData icon,
  required VoidCallback onClicked
}) =>
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(56),
        primary: Colors.white,
        onPrimary: Colors.black,
        textStyle: TextStyle(fontSize: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size:28),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      onPressed: onClicked,
    );
class VideoPlayerWidget extends StatelessWidget {
  final String videoPath;

  const VideoPlayerWidget({Key? key, required this.videoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can use a video player package like 'video_player' to display the captured video
    // Add 'video_player' to your pubspec.yaml file and import it here
    // Example usage: https://pub.dev/packages/video_player

    return Container(
      width: 160,
      height: 160,
      // Your video player widget here
      child: Text('Video Player Placeholder'),
    );
  }
}

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;

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

  // Future<void> uploadVideo(File videoFile) async {
  //   try {
  //     // Encode the video file to base64
  //     List<int> videoBytes = await videoFile.readAsBytes();
  //     String base64Video = base64Encode(videoBytes);
  //
  //     // Prepare the JSON object
  //     Map<String, dynamic> jsonBody = {
  //       'video': base64Video,
  //       // Add other parameters if needed
  //     };
  //
  //     // Convert the JSON object to a string
  //     String jsonString = jsonEncode(jsonBody);
  //     print('jsonString: ${jsonString}');
  //
  //     // Uncomment the following lines when your API is ready
  //     var url = Uri.parse('http://10.0.2.2:5000/upload');  // Update the endpoint URL
  //     final response = await http.post(
  //       url,
  //       body: jsonString,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Video uploaded successfully');
  //     } else {
  //       print('Failed to upload video. Status code: ${response.statusCode}');
  //       print('Error message: ${response.body}');
  //     }
  //
  //   } catch (e) {
  //     print('Error uploading video: $e');
  //   }
  //
  // }
  // Future<void> uploadVideo(File videoFile) async {
  //   try {
  //     // Save the video file to a local directory
  //     String localPath = '/mas_video';
  //     await videoFile.copy(localPath);
  //     print('Video saved locally at: $localPath');
  //
  //     // Encode the video file to base64
  //     List<int> videoBytes = await videoFile.readAsBytes();
  //     String base64Video = base64Encode(videoBytes);
  //
  //     // Prepare the JSON object
  //     Map<String, dynamic> jsonBody = {
  //       'video': base64Video,
  //       'localPath': localPath,  // Include the local path in the JSON
  //       // Add other parameters if needed
  //     };
  //
  //     // Convert the JSON object to a string
  //     String jsonString = jsonEncode(jsonBody);
  //     print('jsonString: ${jsonString}');
  //
  //     // Uncomment the following lines when your API is ready
  //     var url = Uri.parse('http://10.0.2.2:5000/upload');  // Update the endpoint URL
  //     final response = await http.post(
  //       url,
  //       body: jsonString,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Video uploaded successfully');
  //     } else {
  //       print('Failed to upload video. Status code: ${response.statusCode}');
  //       print('Error message: ${response.body}');
  //     }
  //
  //   } catch (e) {
  //     print('Error uploading video: $e');
  //   }
  // }
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
  //     await GallerySaver.saveVideo(video.path);
  //     print('Video Path: ${video.path}');
  //   } on PlatformException catch (e) {
  //     print('Failed to pick video: $e');
  //   }
  // }
  // Future pickVideo(ImageSource source) async {
  //   try {
  //     final video = await ImagePicker().pickVideo(source: source);
  //     if (video == null) return;
  //
  //     final videoTemporary = File(video.path);
  //     setState(() => this.video = videoTemporary);
  //
  //     await uploadVideo(videoTemporary);
  //
  //     print('Video Path: ${video.path}');
  //   } on PlatformException catch (e) {
  //     print('Failed to pick video: $e');
  //   }
  // }
  // Future uploadFile(File file, String endpoint) async {
  //   final request = http.MultipartRequest("POST", Uri.parse(endpoint));
  //   final headers = {"Content-type": "multipart/form-data"};
  //   String message;
  //   request.headers.addAll(headers);
  //
  //   String fileType = file.path.split('.').last;
  //   String fieldName = fileType == 'mp4' ? 'video' : 'image';
  //
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       fieldName,
  //       file.path,
  //     ),
  //   );
  //
  //   try {
  //     final response = await request.send();
  //     final res = await http.Response.fromStream(response);
  //
  //     if (response.statusCode == 200) {
  //       final resJson = jsonDecode(res.body);
  //       message = resJson['message'];
  //       setState(() {});
  //     } else {
  //       print('Failed to upload file. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  // }

  //type null error
  // Future uploadFile(File file, String endpoint) async {
  //   String message;
  //   try {
  //     String fileType = file.path.split('.').last;
  //     String fieldName = fileType == 'mp4' ? 'video' : 'image';
  //
  //     List<int> fileBytes = await file.readAsBytes();
  //     String base64File = base64Encode(fileBytes);
  //
  //     Map<String, dynamic> requestBody = {
  //       "fileType": fileType,
  //       "fileData": base64File,
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse(endpoint),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(requestBody),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final resJson = jsonDecode(response.body);
  //       message = resJson['message'];
  //       setState(() {});
  //     } else {
  //       print('Failed to upload file. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  // }



  Future<void> uploadFile(File videoFile, String apiUrl) async {
    try {
      List<int> videoBytes = await videoFile.readAsBytes();
      String base64Video = base64Encode(videoBytes);

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      Map<String, String> body = {
        "base64_video": base64Video,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Video uploaded successfully");
      } else {
        print("Failed to upload video. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading video: $e");
    }
  }






  Future pickVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) return;

      final videoTemporary = File(video.path);
      setState(() => this.video = videoTemporary);

      await uploadFile(videoTemporary, "http://10.0.2.2:5000/upload");

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



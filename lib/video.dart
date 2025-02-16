import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:mas_dev/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'dart:async';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<VideoPage> {
  File? image;
  File? video;
  List<dynamic> updatedData = [];


  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;
  //
  //     final imageTemporary = File(image.path);
  //     setState(() => this.image = imageTemporary);
  //     await GallerySaver.saveImage(image.path);
  //     print('Image Path: ${image.path}');
  //   }on PlatformException catch(e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  void showSnackbar(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            SizedBox(width: 8.0),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: isSuccess ? Colors.green.withOpacity(0.9) : Colors.red.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  void showSnackbar2(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            SizedBox(width: 8.0),
            Text(message),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: isSuccess ? Colors.green.withOpacity(0.9) : Colors.red.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }



  Future<Map<String, dynamic>> uploadVideo(File videoFile, String apiUrl) async {
    try {
      List<int> videoBytes = await videoFile.readAsBytes();
      String base64Video = base64Encode(videoBytes);

      print("Base64 URL: data:video/mp4;base64,$base64Video");

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      Map<String, String> body = {
        "base64_video": base64Video,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body), // Ensure the body is encoded to JSON
      ).timeout(const Duration(minutes: 5)); // Set a longer timeout duration

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Video uploaded successfully");
        showSnackbar('Video uploaded successfully', true);
        return jsonDecode(response.body);
      } else {
        showSnackbar('Failed to upload video', false);
        print("Failed to upload video. Status Code: ${response.statusCode}");
        return {"success": false};

      }
    } catch (e) {
      showSnackbar('Failed to upload video', false);
      print("Error uploading video: $e");
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> uploadPhoto(File videoFile, String apiUrl) async {
    try {
      List<int> videoBytes = await videoFile.readAsBytes();
      String base64Video = base64Encode(videoBytes);

      print("Base64 URL: data:video/mp4;base64,$base64Video");

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      Map<String, String> body = {
        "base64_photo": base64Video,
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body), // Ensure the body is encoded to JSON
      ).timeout(const Duration(minutes: 5)); // Set a longer timeout duration

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("Photo uploaded successfully");
        showSnackbar('Photo uploaded successfully', true);
        return jsonDecode(response.body);
      } else {
        showSnackbar('Failed to upload image', false);
        print("Failed to upload image. Status Code: ${response.statusCode}");
        return {"success": false};

      }
    } catch (e) {
      showSnackbar('Failed to upload photo', false);
      print("Error uploading photo: $e");
      return {"success": false};
    }
  }



  Future<void> pickVideo(ImageSource source) async {
    try {
      final videoFile = await ImagePicker().pickVideo(source: source);
      if (videoFile == null) return;

      final videoTemporary = File(videoFile.path);

      // If the video is taken from the camera, save it to the gallery
      if (source == ImageSource.camera) {
        final appDir = await getApplicationDocumentsDirectory();

        // Generate a timestamp for the video file name
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final newVideoPath = '${appDir.path}/video_$timestamp.mp4';

        // Copy the temporary video to the new path
        await videoTemporary.copy(newVideoPath);

        // Save the new video path to the gallery
        await GallerySaver.saveVideo(newVideoPath);
      }

      // Optionally, you can set the state with the picked video
      setState(() {
        this.video = videoTemporary; // Store the picked video in the state
      });

      // Assume uploadVideo is a function you defined elsewhere
      final response = await uploadVideo(videoTemporary, "http://49.206.252.212:35001/upload-video");
      if (response != null && response['success'] == true) {
        showSnackbar2('Processed successfully.', true);
        final List<dynamic> markedData = response['marked_data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Entries(markedData: markedData),
          ),
        );
      } else {
        showSnackbar2('Failed to process video data.', false);
        print('Failed to process video data.');
      }

    } on PlatformException catch (e) {
      print('Failed to pick video: $e');
    }
  }









  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      final response = await uploadPhoto(imageTemporary, "http://49.206.252.212:35001/upload-photo");
      if (response != null && response['success'] == true) {
        showSnackbar2('Processed successfully.', true);
        final List<dynamic> markedData = response['marked_data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Entries(markedData: markedData),
          ),
        );
      } else {
        showSnackbar2('Failed to process image data.', false);
        print('Failed to process image data.');
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80.0,left:30.0), // Added padding to move text down
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text(
                    'Upload Document',
                    style: TextStyle(
                        color: Color(0xFF98ABEE), // Changed text color
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Provide a video or photo of the class under visible lighting to mark the attendance.',
                    style: TextStyle(
                        color: Color(0xFFF9E8C9), // Changed text color
                        fontSize: 18.0,
                    ),
                  ),
                ],
              ),

            ),

            SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    ),
                    const SizedBox(height:24),
                    buildButton(
                      title: 'Upload Photo',
                      icon: Icons.image_outlined,
                        onClicked: () => pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(height:24),
                    buildButton(
                      title: 'Take Photo',
                      icon: Icons.camera_alt_outlined,
                      onClicked: ()=>pickImage(ImageSource.camera),
                    ),


                  ],
                ),
              ),
            ),

                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => Entries()),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //         primary: Color(0xFF201658),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(20), // Adjust the value to change roundness
                //         ),
                //       side: BorderSide(color: Color(0xFF98ABEE), width: 1),
                //     ),
                //     child: Text('Check Entries')
                //
                // ),
            SizedBox(height:20)



            ]),




        ),
        backgroundColor: Color(0xFF201658),
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
        primary: Color(0xFF98ABEE),
        onPrimary: Color(0xFFF9E8C9),
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
    return Container(
      width: 160,
      height: 160,
      // Your video player widget here
      child: Text('Video Player Placeholder'),
    );
  }
}



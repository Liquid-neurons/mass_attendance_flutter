import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:ai_collabaration2/app.dart';




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
        body: jsonEncode(body), // Set a longer timeout duration (in seconds)
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

  Future<void> fetchAndDisplayUpdatedData() async {
    var updatedDataResponse = await http.get(Uri.parse("http://49.206.252.212:5001/return_csv"));

    if (updatedDataResponse.statusCode == 200) {
      setState(() {
        updatedData = jsonDecode(updatedDataResponse.body);
      });
    } else {
      print("Failed to fetch updated data. Status Code: ${updatedDataResponse.statusCode}");
    }
  }

  Future<void> clearEntries() async {
    var clearEntriesResponse = await http.post(
      Uri.parse("http://49.206.252.212:5001/clear_csv"),
    );

    if (clearEntriesResponse.statusCode == 200) {
      print("CSV file cleared successfully.");
      // Refresh the UI to reflect the changes (optional)
      fetchAndDisplayUpdatedData();
    } else {
      print("Failed to clear CSV file. Status Code: ${clearEntriesResponse.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndDisplayUpdatedData();
  }




  Future pickVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) return;

      final videoTemporary = File(video.path);
      setState(() => this.video = videoTemporary);

      await uploadFile(videoTemporary, "http://49.206.252.212:5001/upload");

      print('Video Path: ${video.path}');
    } on PlatformException catch (e) {
      print('Failed to pick video: $e');
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
                    'Upload Video',
                    style: TextStyle(
                        color: Color(0xFF98ABEE), // Changed text color
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Provide a video of the class under visible lighting to mark the attendance.',
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


                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      fetchAndDisplayUpdatedData();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF201658),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Adjust the value to change roundness
                        ),
                      side: BorderSide(color: Color(0xFF98ABEE), width: 1),
                    ),
                    child: Text('Check Entries')

                ),
                const SizedBox(width: 40,),
                ElevatedButton(
                    onPressed: () {
                      clearEntries();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF201658),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Adjust the value to change roundness
                      ),
                      side: BorderSide(color: Color(0xFF98ABEE), width: 1),
                    ),
                    child: Text('Clear Entries')

                ),
              ],
            ),
            SizedBox(height: 20),
            if (updatedData.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: <DataColumn>[
                    for (var key in updatedData[0].keys)
                      DataColumn(label: Text(key.toString())),
                  ],
                  rows: <DataRow>[
                    for (var entry in updatedData)
                      DataRow(
                        cells: <DataCell>[
                          for (var value in entry.values)
                            DataCell(Text(value.toString())),
                        ],
                      ),
                  ],
                ),
              ),




          ],

        ),
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



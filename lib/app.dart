// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
//
// class EntiresPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mass Attendance',
//       home: Entries(),
//     );
//   }
// }
//
// class Entries extends StatelessWidget {
//   //final Function functionToCall;
//
//   //const Entries({Key? key, required this.functionToCall}) : super(key: key);
//   Future<void> fetchAndDisplayUpdatedData() async {
//     print("In function");
//     // Fetch updated CSV data from your API
//     var updatedDataResponse = await http.get(Uri.parse("http://49.206.252.212:5001/return_csv"));
//
//     if (updatedDataResponse.statusCode == 200) {
//       // Parse the CSV data and update the UI
//       List<dynamic> updatedData = jsonDecode(updatedDataResponse.body);
//
//       // TODO: Update your UI with the fetched data
//       print("Updated Data: $updatedData");
//     } else {
//       print("Failed to fetch updated data. Status Code: ${updatedDataResponse.statusCode}");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     fetchAndDisplayUpdatedData();
//     return Scaffold(
//
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("new page"),
//             SizedBox(height: 20),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Entries extends StatefulWidget { // Changed to StatefulWidget
  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  List<dynamic> updatedData = []; // Store fetched data

  Future<void> fetchAndDisplayUpdatedData() async {
    var updatedDataResponse = await http.get(Uri.parse("http://49.206.252.212:5001/return_csv"));

    if (updatedDataResponse.statusCode == 200) {
      setState(() { // Update UI state
        updatedData = jsonDecode(updatedDataResponse.body);
      });
      print("Updated Data: $updatedData");
    } else {
      print("Failed to fetch updated data. Status Code: ${updatedDataResponse.statusCode}");
    }
  }

  @override
  void initState() { // Fetch data on initialization
    super.initState();
    fetchAndDisplayUpdatedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            if (updatedData.isNotEmpty) // Conditionally display data
              ListView.builder( // Display data in a list
                shrinkWrap: true, // Prevent excessive scrolling
                itemCount: updatedData.length,
                itemBuilder: (context, index) {
                  return Text(updatedData[index].toString()); // Display each item
                },
              ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next page
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => Entries(),
                  ),
                );
              },
              child: Text('Clear Entries'),
            ),
          ],
        ),
      ),
    );
  }
}

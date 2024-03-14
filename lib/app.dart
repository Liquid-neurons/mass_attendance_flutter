// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// class Entries extends StatefulWidget { // Changed to StatefulWidget
//   @override
//   _EntriesState createState() => _EntriesState();
// }
//
// class _EntriesState extends State<Entries> {
//   List<dynamic> updatedData = []; // Store fetched data
//
//   Future<void> fetchAndDisplayUpdatedData() async {
//     var updatedDataResponse = await http.get(Uri.parse("http://49.206.252.212:5001/return_csv"));
//
//     if (updatedDataResponse.statusCode == 200) {
//       setState(() { // Update UI state
//         updatedData = jsonDecode(updatedDataResponse.body);
//       });
//       print("Updated Data: $updatedData");
//     } else {
//       print("Failed to fetch updated data. Status Code: ${updatedDataResponse.statusCode}");
//     }
//   }
//
//   @override
//   void initState() { // Fetch data on initialization
//     super.initState();
//     fetchAndDisplayUpdatedData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//             if (updatedData.isNotEmpty) // Conditionally display data
//               ListView.builder( // Display data in a list
//                 shrinkWrap: true, // Prevent excessive scrolling
//                 itemCount: updatedData.length,
//                 itemBuilder: (context, index) {
//                   return Text(updatedData[index].toString()); // Display each item
//                 },
//               ),
//             SizedBox(height: 20,),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate to the next page
//                 Navigator.push(
//                   context,
//
//                   MaterialPageRoute(
//                     builder: (context) => Entries(),
//                   ),
//                 );
//               },
//               child: Text('Clear Entries'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Entries extends StatefulWidget {
  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  List<dynamic> updatedData = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                clearEntries();
              },
              child: Text('Clear Entries'),
            ),
          ],
        ),
      ),
    );
  }
}

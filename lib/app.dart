import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'card.dart';



class Entries extends StatefulWidget {
  final List<dynamic> markedData;

  Entries({required this.markedData});

  @override
  _EntriesState createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredData = [];
  List<String> suggestions = [];

  @override
  void initState() {
    super.initState();
    filteredData = widget.markedData;
    searchController.addListener(() {
      filterData();
    });
  }

  void filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredData = widget.markedData.where((data) {
        String name = data['Name'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
      suggestions = widget.markedData
          .map((data) => data['Name'].toString())
          .where((name) => name.toLowerCase().contains(query))
          .take(4)
          .toList();
    });
  }

  void showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data['Name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${data['Name']}'),
              Image.memory(
                base64Decode(data['Image']), // Use the correct asset path
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              Text('ID: ${data['ID']}'),
              Text('Date: ${data['Date']}'),
              Text('Time: ${data['Time']}'),
              Text('Status: ${data['Status']}')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double searchBarHeight = 40.0;
    double gridPadding = 8.0;
    double appBarHeight = 40;

    // Available height for the grid
    double availableHeight =
        screenHeight - appBarHeight - searchBarHeight - (4 * gridPadding);

    // Calculate item height
    double itemHeight = (availableHeight - 50) / 3;
    double itemWidth = (screenWidth - (3 * gridPadding)) / 2;

    List<Widget> cards = List.generate(filteredData.length, (index) {
      final data = filteredData[index];
      return CustomCard(
        name: data['Name'],
        id: data['ID'],
        image: data['Image'],
        onTap: () => showDetailsDialog(context, data),
      );
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        title: Text('Response Page'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                        : null,
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 6.0,
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return cards[index];
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 46.0, // position below the search bar
            left: 6.0,
            right: 6.0,
            child: searchController.text.isNotEmpty && suggestions.isNotEmpty
                ? Card(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      searchController.text = suggestions[index];
                      filterData();
                    },
                  );
                },
              ),
            )
                : SizedBox.shrink(),
          ),
        ],
      ),
      backgroundColor: Color(0xFF201658),
    );
  }
}
//search bar working functionality
// class Entries extends StatefulWidget {
//   final List<dynamic> markedData;
//
//   Entries({required this.markedData});
//
//   @override
//   _EntriesState createState() => _EntriesState();
// }
//
// class _EntriesState extends State<Entries> {
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> filteredData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredData = widget.markedData;
//     searchController.addListener(() {
//       filterData();
//     });
//   }
//
//   void filterData() {
//     String query = searchController.text.toLowerCase();
//     setState(() {
//       filteredData = widget.markedData.where((data) {
//         String name = data['Name'].toString().toLowerCase();
//         return name.contains(query);
//       }).toList();
//     });
//   }
//
//   void showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(data['Name']),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Name: ${data['Name']}'),
//               Image.asset(
//                 'assets/profile_pic.png', // Use the correct asset path
//                 height: 200,
//                 width: 200,
//                 fit: BoxFit.cover,
//               ),
//               Text('ID: ${data['ID']}'),
//               Text('Date: ${data['Date']}'),
//               Text('Time: ${data['Time']}'),
//               Text('Status: ${data['Status']}')
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     double searchBarHeight = 40.0;
//     double gridPadding = 8.0;
//     double appBarHeight = 40;
//
//     // Available height for the grid
//     double availableHeight =
//         screenHeight - appBarHeight - searchBarHeight - (4 * gridPadding);
//
//     // Calculate item height
//     double itemHeight = (availableHeight - 50) / 3;
//     double itemWidth = (screenWidth - (3 * gridPadding)) / 2;
//
//     List<Widget> cards = List.generate(filteredData.length, (index) {
//       final data = filteredData[index];
//       return CustomCard(
//         name: data['Name'],
//         id: data['ID'],
//         onTap: () => showDetailsDialog(context, data),
//       );
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: appBarHeight,
//         title: Text('Response Page'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 suffixIcon: searchController.text.isNotEmpty
//                     ? IconButton(
//                   icon: Icon(Icons.clear),
//                   onPressed: () {
//                     searchController.clear();
//                   },
//                 )
//                     : null,
//                 hintText: 'Search',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30.0),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 contentPadding:
//                 EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8.0),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 6.0,
//                 mainAxisSpacing: 6.0,
//                 childAspectRatio: itemWidth / itemHeight,
//               ),
//               itemCount: cards.length,
//               itemBuilder: (context, index) {
//                 return cards[index];
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


//preview button function
// Future<void> sendPostRequest(String id, BuildContext context) async {
//   print(id);
//   final url = 'http://49.206.252.212:5001/get-image'; // Replace with your server URL
//   Map<String, String> headers = {
//     "Content-Type": "application/json",
//     "Accept": "application/json"
//   };
//   var response = await http.post(
//     Uri.parse(url),
//     headers: headers,
//     body: jsonEncode({'ID': id}),
//   );
//
//   if (response.statusCode == 200) {
//     final jsonData = jsonDecode(response.body);
//     final image= jsonData['Image'];
//     print(image);
//     // Handle successful response
//     print('Success: ${response.body}');
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Success'),
//           content: Image.memory(base64Decode(image)),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     // Handle error response
//     print('Error: ${response.body}');
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(response.body),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// table format

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('Response Page'),
//     ),
//     body: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columns: [
//           DataColumn(label: Text('Name')),
//           DataColumn(label: Text('Date')),
//           DataColumn(label: Text('Time')),
//           DataColumn(label: Text('ID')),
//           DataColumn(label: Text('Status')),
//           DataColumn(label: Text('Action')),
//         ],
//         rows: markedData.map((data) {
//           return DataRow(
//             cells: [
//               DataCell(Text('${data['Name']}')),
//               DataCell(Text('${data['Date']}')),
//               DataCell(Text('${data['Time']}')),
//               DataCell(Text('${data['ID']}')),
//               DataCell(Text('${data['Status']}')),
//               DataCell(
//                 TextButton(
//                   onPressed: () {
//                     sendPostRequest(data['ID'], context);
//                   },
//                   child: Text('Send'),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     ),
//   );


// working 6 cards, no on tap feature
//   @override
//   Widget build(BuildContext context) {
//     int totalCards = 6;
//     List<Widget> cards = List.generate(markedData.length, (index) {
//       final data = markedData[index];
//       return CustomCard(
//         name: data['Name'],
//         id: data['ID'],
//       );
//     });
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Response Page'),
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//           childAspectRatio: (MediaQuery.of(context).size.width / 2) /
//               ((MediaQuery.of(context).size.height - kToolbarHeight - 16) / 3),
//         ),
//         itemCount: totalCards,
//         itemBuilder: (context, index) {
//           if (index < cards.length) {
//             return cards[index];
//           } else {
//             return SizedBox.shrink(); // Empty widget for empty spots
//           }
//         },
//       ),
//     );
//   }
// }
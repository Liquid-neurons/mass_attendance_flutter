import 'package:flutter/material.dart';

class NewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Institution Registration',
      theme: ThemeData(
        primaryColor: Color(0xFF201658),
        scaffoldBackgroundColor: Color(0xFF201658),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFFF9E8C9)),
          bodyText2: TextStyle(color: Color(0xFFF9E8C9)),
        ),
      ),
      home: InstitutionRegistrationPage(),
    );
  }
}

class InstitutionRegistrationPage extends StatefulWidget {
  @override
  _InstitutionRegistrationPageState createState() =>
      _InstitutionRegistrationPageState();
}

class _InstitutionRegistrationPageState
    extends State<InstitutionRegistrationPage> {
  late String institutionName;
  late String email;
  late String numberOfStudents;
  late String numberOfSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Institution Name',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            TextFormField(
              onChanged: (value) {
                institutionName = value;
              },
              style: TextStyle(color: Color(0xFFF9E8C9)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF98ABEE),
                hintText: '    Enter Institution Name',
                hintStyle: TextStyle(color: Color(0xFFF9E8C9)), // Hint text color
                contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust the height here
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Email',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 8),
            TextFormField(
              onChanged: (value) {
                email = value;
              },
              style: TextStyle(color: Color(0xFFF9E8C9)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF98ABEE),
                hintText: '    Enter Email',
                hintStyle: TextStyle(color: Color(0xFFF9E8C9)), // Hint text color
                contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust the height here
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of Students',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) {
                          numberOfStudents = value;
                        },
                        style: TextStyle(color: Color(0xFFF9E8C9)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF98ABEE),
                          hintText: '    No.of Students',
                          hintStyle: TextStyle(color: Color(0xFFF9E8C9)), // Hint text color
                          contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust the height here
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of Sections',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) {
                          numberOfSections = value;
                        },
                        style: TextStyle(color: Color(0xFFF9E8C9)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF98ABEE),
                          hintText: '    No.of Sections',
                          hintStyle: TextStyle(color: Color(0xFFF9E8C9)), // Hint text color
                          contentPadding: EdgeInsets.symmetric(vertical: 12), // Adjust the height here
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Submit action
                print('Institution Name: $institutionName');
                print('Email: $email');
                print('Number of Students: $numberOfStudents');
                print('Number of Sections: $numberOfSections');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF98ABEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Adjust the value to change roundness
                ),
                // Changed button color
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center( // Centering the text vertically
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF9E8C9),
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

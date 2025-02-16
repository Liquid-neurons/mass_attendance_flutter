import 'package:flutter/material.dart';
import 'package:mas_dev/video.dart';

class InstituteDeptForm extends StatefulWidget {
  const InstituteDeptForm({super.key});

  @override
  _InstituteDeptFormState createState() => _InstituteDeptFormState();
}

class _InstituteDeptFormState extends State<InstituteDeptForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _instituteIdController = TextEditingController();
  final TextEditingController _deptIdController = TextEditingController();

  @override
  void dispose() {
    _instituteIdController.dispose();
    _deptIdController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Institute and Department Form',
      theme: ThemeData(
        primaryColor: const Color(0xFF201658),
        scaffoldBackgroundColor: const Color(0xFF201658),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Color(0xFFF9E8C9)),
          bodyText2: TextStyle(color: Color(0xFFF9E8C9)),
        ),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Institute ID',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFF9E8C9),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _instituteIdController,
                  style: const TextStyle(color: Color(0xFFF9E8C9)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF98ABEE),
                    hintText: 'Enter Institute ID',
                    hintStyle: const TextStyle(color: Color(0xFFF9E8C9)),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, // Adjusted for better cursor positioning
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Institute ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Department ID',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFF9E8C9),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deptIdController,
                  style: const TextStyle(color: Color(0xFFF9E8C9)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF98ABEE),
                    hintText: 'Enter Department ID',
                    hintStyle: const TextStyle(color: Color(0xFFF9E8C9)),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, // Adjusted for better cursor positioning
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Department ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF98ABEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
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
        ),
      ),
    );
  }
}

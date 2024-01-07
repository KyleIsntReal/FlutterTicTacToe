import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'main_screen.dart';

class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String enteredName = _nameController.text;
                saveNameToCSV(enteredName); // Save the entered name to CSV
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  void saveNameToCSV(String name) async {
    
    String filePath = 'Flutter_Tic_Tac_Toe/lib/assets/scores.csv';

    final file = File(filePath);

    // Read existing content
    String currentContent = await file.readAsString();

    // Append the new name to the CSV content
    String newContent = '$currentContent$name\n';

    // Write the updated content back to the file
    await file.writeAsString(newContent);
  }
}

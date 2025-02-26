import 'package:flutter/material.dart';
import 'package:flutter_application_4/services/firestore.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  final FirestoreServices firestore = FirestoreServices();
  
  final TextEditingController textController = TextEditingController();
  void showNoteBox() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: textController),

            actions: [
              ElevatedButton(
                onPressed: () {
                  firestore.addNote(textController.text);

                  textController.clear();
                  Navigator.pop(context);
                },
                child: Text('add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteBox();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

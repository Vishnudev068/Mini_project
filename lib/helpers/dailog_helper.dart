import 'package:flutter/material.dart';

class DialogHelper {
   void showDialogContainer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Enter your name",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

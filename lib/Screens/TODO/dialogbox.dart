import 'package:flutter/material.dart';
import 'mybutton.dart';

class DialogBox extends StatelessWidget {
  final Controller;
  VoidCallback onsave;
  VoidCallback oncancel;
  DialogBox(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.Controller,
      required this.onsave,
      required this.oncancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow,
      content: SizedBox(
        height: 120,
        child: Column(children: [
          TextField(
            controller: Controller,
            decoration: const InputDecoration(
                hintText: 'Add Task', focusColor: Colors.grey),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Mybutton(onPressed: onsave, text: "Save"),
              // SizedBox(width: 5),
              // Mybutton(onPressed: oncancel, text: "Cancel"),
            ],
          )
        ]),
      ),
    );
  }
}

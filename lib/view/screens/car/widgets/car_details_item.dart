import 'package:flutter/material.dart';

class CarDetailsItem extends StatelessWidget {
  final String title;
  final String? content;
  final bool editable;
  final void Function(String) onUpdate;

  const CarDetailsItem({super.key, required this.title, required this.content, required this.onUpdate, this.editable = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: editable
          ? () {
              TextEditingController controller = TextEditingController(text: content ?? '');
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(title),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      content: TextField(controller: controller, decoration: InputDecoration(hintText: title)),
                      actions: [
                        TextButton(
                            onPressed: () {
                              onUpdate(controller.text);
                              Navigator.pop(ctx);
                            },
                            child: const Text('OK'))
                      ],
                    );
                  });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
            Expanded(flex: 2, child: Text(content ?? "Undefined", style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }
}

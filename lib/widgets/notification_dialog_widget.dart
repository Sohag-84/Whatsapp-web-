import 'package:flutter/material.dart';

class NotificationDialogWidget extends StatelessWidget {
  final String title;
  final String bodyText;
  const NotificationDialogWidget({
    super.key,
    required this.title,
    required this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          label: const Text('Close'),
        )
      ],
      content: bodyText.contains('.jpg')
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Send you message"),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Image.network(
                    bodyText,
                    height: 160,
                    width: 160,
                  ),
                ),
              ],
            )
          : bodyText.contains(".pdf") ||
                  bodyText.contains(".pptx") ||
                  bodyText.contains(".xlsx") ||
                  bodyText.contains(".mp4") ||
                  bodyText.contains(".mp3") ||
                  bodyText.contains(".docx")
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Send you message"),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        'assets/images/file.png',
                        height: 160,
                        width: 160,
                      ),
                    ),
                  ],
                )
              : Text(bodyText),
    );
  }
}

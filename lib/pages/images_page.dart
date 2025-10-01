import 'package:flutter/material.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/images/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              "https://raw.githubusercontent.com/flutter/packages/refs/heads/main/packages/video_player/video_player/example/assets/flutter-mark-square-64.png",
              width: 64,
              height: 64,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  if (loadingProgress.expectedTotalBytes == null) {
                    return CircularProgressIndicator();
                  } else {
                    return CircularProgressIndicator(
                      value:
                          loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!,
                    );
                  }
                }
              },
            ),
            Text("Network Image"),
            Image.asset("assets/flutter-mark.png", width: 64, height: 64),
            Text("Asset Image"),
          ],
        ),
      ),
    );
  }
}

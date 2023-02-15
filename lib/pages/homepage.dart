import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<SharedMedia>? _streamSubscription;
  SharedMedia? media;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    final handler = ShareHandlerPlatform.instance;
    media = await handler.getInitialSharedMedia();
    _streamSubscription = handler.sharedMediaStream.listen((SharedMedia media) {
      if (!mounted) return;
      setState(() => this.media = media);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Handler'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Shared to conversation identifier: ${media?.conversationIdentifier}',
          ),
          const SizedBox(height: 10),
          Text('Shared text: ${media?.content}'),
          const SizedBox(height: 10),
          Text('Shared files: ${media?.attachments?.length}'),
          ...(media?.attachments ?? []).map((attachment) {
            final path = attachment?.path;
            if (path != null &&
                attachment?.type == SharedAttachmentType.image) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ShareHandlerPlatform.instance.recordSentMessage(
                        conversationIdentifier:
                            'custom-conversation-identifier',
                        conversationName: 'John Doe',
                        conversationImageFilePath: path,
                        serviceName: 'custom-service-name',
                      );
                    },
                    child: const Text('Record message'),
                  ),
                  const SizedBox(height: 10),
                  Image.file(File(path)),
                ],
              );
            }
            return Text(
              '${attachment?.type} Attachment: ${attachment?.path}',
            );
          }),
        ],
      ),
    );
  }
}

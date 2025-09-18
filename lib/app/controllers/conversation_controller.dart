import 'dart:io';

import 'package:dot_connections/app/models/conversation_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ConversationController extends GetxController {
  final messages = <Message>[
    Message(
      text: 'Hey, saw your dot near the café yesterday. You go there often?',
      isMe: false,
      type: MessageType.text,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Yeah, I work there sometimes. How about you?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
    Message(
      text: 'Same! Want to grab a coffee together?',
      isMe: false,
      type: MessageType.text,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Sure, this weekend?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
    Message(
      isMe: false,
      type: MessageType.audio,
      userAvatar: 'assets/images/Annette_Black.png',
    ),
    Message(
      text: 'Sure, this weekend?',
      isMe: true,
      type: MessageType.text,
      userAvatar: 'assets/images/Eleanor_Pena.png',
    ),
  ].obs;

  var image = Rxn<XFile>();
  final imagePicker = ImagePicker();

  ///recording
  final _recording = false.obs;

  ///recorded file path
  final RxString _path = RxString('');
  String? get audioPath => _path.value;

  bool get isRecording => _recording.value;
  set isRecording(bool value) => _recording.value = value;

  ///audio recorder instance
  final AudioRecorder _audioRecorder = AudioRecorder();

  ///controller for text field
  final messageFeildController = TextEditingController();

  Future<void> _startRecording() async {
    debugPrint('Starting recording...');
    if (await _audioRecorder.hasPermission()) {
      debugPrint('permission have...');

      final directory = await getApplicationDocumentsDirectory();

      await _audioRecorder.start(
        const RecordConfig(
          //first argument required
          encoder: AudioEncoder.wav, // or opus, wav, etc.
          bitRate: 128000,
          sampleRate: 44100,
        ),
        //named argument
        path:
            "${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav",
      );
    } else {
      debugPrint('No recording permission granted');
    }
  }

  void toggleRecording() async {
    if (isRecording) {
      // Stop recording
      final recordeAudiodPath = await _audioRecorder.stop();
      isRecording = false;

      ///check if path is null
      if (recordeAudiodPath == null) {
        (true);
        _recording(false);
        debugPrint('Recording failed, no file path returned');
        update();
        return;
      }

      final file = File(recordeAudiodPath);
      if (!await file.exists()) {
        (false);
        _recording(false);
        debugPrint(
          'Recording failed, file does not exist at path: $recordeAudiodPath',
        );
        update();
        return;
      }
      debugPrint('Recorded file size: ${await file.length()} bytes');

      _recording(false);
      _path.value = recordeAudiodPath;
      debugPrint(
        'Recording stopped, file saved. and stored in variable $_path',
      );

      update();
    } else {
      // Start recording
      await _startRecording();
      isRecording = true;
      update();
    }
  }

  //image picker
  void pickImage() async {
    try {
      final imagePicked = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (imagePicked == null) {
        return;
      } else {}
    } catch (e) {
      debugPrint('error to pick the image> $e');
    }
  }

  // Send text message
  void sendTextMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add(
      Message(
        text: text,
        isMe: true,
        type: MessageType.text,
        userAvatar: 'assets/images/Eleanor_Pena.png',
      ),
    );

    update();
  }

  // Send audio message
  void sendAudioMessage(String audioPath) {
    if (audioPath.isEmpty) return;

    messages.add(
      Message(
        isMe: true,
        type: MessageType.audio,
        userAvatar: 'assets/images/Eleanor_Pena.png',
        audioPath: audioPath,
      ),
    );

    // Clear the recorded audio path
    _path.value = '';

    update();
  }

  // Clear audio recording without sending
  void clearAudio() {
    // Delete the audio file if needed
    if (_path.value.isNotEmpty) {
      try {
        final file = File(_path.value);
        if (file.existsSync()) {
          file.deleteSync();
          debugPrint('Deleted audio file: ${_path.value}');
        }
      } catch (e) {
        debugPrint('Error deleting audio file: $e');
      }
    }

    // Clear the path
    _path.value = '';
    update();
  }
}

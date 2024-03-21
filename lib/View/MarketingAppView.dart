import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketing_application/Widget/VideoPlayerWidget.dart';

import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketingApp extends StatefulWidget {
  const MarketingApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MarketingAppState createState() => _MarketingAppState();
}

class _MarketingAppState extends State<MarketingApp> {
  File? _image;
  File? _video;
  String? _textContent;
  Color _contentColor = Colors.black;
  double _fontSize = 20.0;

  final TextEditingController _textEditingController = TextEditingController();

  final picker = ImagePicker();
  String _selectedFontFamily = 'Roboto';
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _recordVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    setState(() {
      _video = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void _shareContentToSocialMedia() {
    if (_textContent != null && _textContent!.isNotEmpty) {
      Share.share(_textContent!);
    } else if (_image != null) {
      // ignore: deprecated_member_use
      Share.shareFiles([_image!.path], text: _textContent ?? '');
    } else if (_video != null) {
      // ignore: deprecated_member_use
      Share.shareFiles([_video!.path], text: _textContent ?? '');
    } else {
      print('No content to share');
    }
  }

  String _getColorName(Color color) {
    if (color == Colors.black) {
      return 'Black';
    } else if (color == Colors.red) {
      return 'Red';
    } else if (color == Colors.green) {
      return 'Green';
    } else if (color == Colors.blue) {
      return 'Blue';
    } else {
      return 'Unknown';
    }
  }

  List<String> templates = ['Template 1', 'Template 2', 'Template 3'];
  void _previewContent(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1,
          child: AlertDialog(
            title: const Text('Preview'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_textContent != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _textContent!,
                        style: GoogleFonts.getFont(
                          _selectedFontFamily,
                          fontSize: _fontSize,
                          color: _contentColor,
                        ),
                      ),
                    ),
                  if (_image != null)
                    Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  if (_video != null)
                    VideoPlayerWidget(
                      videoPlayerController:
                          VideoPlayerController.file(_video!),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Digital Content Creator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blueGrey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                _shareContentToSocialMedia();
                              },
                              icon: const Icon(Icons.share))),
                      CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                _enterText(context);
                              },
                              icon: const Icon(Icons.edit))),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () {
                              _recordVideo();
                            },
                            icon: const Icon(Icons.video_call_outlined)),
                      ),
                      CircleAvatar(
                        child: IconButton(
                            onPressed: () {
                              _pickImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.camera_alt)),
                      ),
                      CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                _previewContent(context);
                              },
                              icon: const Icon(Icons.preview))),
                    ],
                  ),
                ),
                if (_video != null)
                  VideoPlayerWidget(
                    videoPlayerController: VideoPlayerController.file(_video!),
                  ),
                if (_textContent != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _textContent!,
                      style: GoogleFonts.getFont(_selectedFontFamily,
                          fontSize: _fontSize, color: _contentColor),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _enterText(BuildContext context) async {
    String? text = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Text'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textEditingController,
                onChanged: (value) {
                  _textContent = value;
                },
                decoration:
                    const InputDecoration(hintText: 'Enter your text here'),
              ),
              const SizedBox(height: 10),
              const Text('Select Font:'),
              DropdownButton<String>(
                value: _selectedFontFamily,
                onChanged: (value) {
                  setState(() {
                    _selectedFontFamily = value!;
                  });
                },
                items: GoogleFonts.asMap().keys.map((String fontFamily) {
                  return DropdownMenuItem<String>(
                    value: fontFamily,
                    child: Text(fontFamily),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Text Color:'),
                  DropdownButton<Color>(
                    value: _contentColor,
                    onChanged: (value) {
                      setState(() {
                        _contentColor = value!;
                      });
                    },
                    items: <Color>[
                      Colors.black,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ].map<DropdownMenuItem<Color>>((Color color) {
                      String colorName = _getColorName(color);
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Text(colorName),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Font Size:'),
                  Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 40.0,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _textContent = _textEditingController.text;
                });
                Navigator.of(context).pop(_textContent);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (text != null) {
      setState(() {
        _textContent = text;
      });
    }
  }
}

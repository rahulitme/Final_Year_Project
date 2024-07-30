import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceColorDetectorScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  FaceColorDetectorScreen({required this.cameras});

  @override
  _FaceColorDetectorScreenState createState() => _FaceColorDetectorScreenState();
}

class _FaceColorDetectorScreenState extends State<FaceColorDetectorScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Color detectedColor = Colors.white;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: false,
      enableLandmarks: true,
      enableTracking: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        await _uploadFileToFirebase(_image!);
        await detectFaceColor(_image!);
      }
    } catch (e) {
      print("Error picking image: $e");
      _showNotification('Error picking image', isError: true);
    }
  }

  Future<void> _uploadFileToFirebase(File file) async {
    try {
      String storagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpeg';
      Reference ref = _storage.ref().child(storagePath);
      UploadTask uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
      }, onError: (e) {
        print('Error during upload: $e');
        _showNotification('Error uploading image', isError: true);
      }, onDone: () async {
        String downloadURL = await ref.getDownloadURL();
        print('File uploaded. Download URL: $downloadURL');
        _showNotification('Image uploaded successfully');
      });

      await uploadTask;
    } catch (e) {
      print("Error uploading file: $e");
      _showNotification('Error uploading image', isError: true);
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> detectFaceColor(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;
      final imageBytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        final cheekX = (face.boundingBox.left + face.boundingBox.right) ~/ 2;
        final cheekY = (face.boundingBox.top + 3 * face.boundingBox.bottom) ~/ 4;

        final cheekPixel = decodedImage.getPixel(cheekX, cheekY);
        final r = img.getRed(cheekPixel);
        final g = img.getGreen(cheekPixel);
        final b = img.getBlue(cheekPixel);

        setState(() {
          detectedColor = Color.fromRGBO(r, g, b, 1);
          isValid = true;
        });

        await FirebaseAnalytics.instance.logEvent(
          name: 'face_color_detected',
          parameters: {
            'r': r,
            'g': g,
            'b': b,
          },
        );
      }
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Color Detector')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      CameraPreview(_controller),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final image = await _controller.takePicture();
                          setState(() {
                            _image = File(image.path);
                          });
                          await detectFaceColor(_image!);
                          await _uploadFileToFirebase(_image!);
                        },
                        child: Text('Detect Face Color'),
                      ),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: 20),
            _image == null
                ? Text('No image selected.')
                : Image.file(_image!, height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              child: Text('Take Picture'),
            ),
            SizedBox(height: 20),
            isValid
                ? Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: detectedColor,
                      ),
                      Text('Detected Face Color: ${detectedColor.toString()}'),
                    ],
                  )
                : Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// //import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class ClothingColorRecommender extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ClothingColorRecommender({required this.cameras});

//   @override
//   _ClothingColorRecommenderState createState() => _ClothingColorRecommenderState();
// }

// class _ClothingColorRecommenderState extends State<ClothingColorRecommender> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   Color detectedColor = Colors.white;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableClassification: false,
//       enableLandmarks: true,
//       enableTracking: false,
//       performanceMode: FaceDetectorMode.fast,
//     ),
//   );
//   bool isValid = false;
//   List<Map<String, Color>> recommendedColors = [];
//   String selectedGender = 'Male';
//   String skinToneCategory = 'Medium';

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }

//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path);
//         });

//         await _uploadFileToFirebase(_image!);
//         await detectFaceColor(_image!);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       _showNotification('Error picking image', isError: true);
//     }
//   }

//   Future<void> _uploadFileToFirebase(File file) async {
//     try {
//       String storagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpeg';
//       Reference ref = _storage.ref().child(storagePath);
//       UploadTask uploadTask = ref.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
//       }, onError: (e) {
//         print('Error during upload: $e');
//         _showNotification('Error uploading image', isError: true);
//       }, onDone: () async {
//         String downloadURL = await ref.getDownloadURL();
//         print('File uploaded. Download URL: $downloadURL');
//         _showNotification('Image uploaded successfully');
//       });

//       await uploadTask;
//     } catch (e) {
//       print("Error uploading file: $e");
//       _showNotification('Error uploading image', isError: true);
//     }
//   }

//   void _showNotification(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> detectFaceColor(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final faces = await _faceDetector.processImage(inputImage);

//     if (faces.isNotEmpty) {
//       final face = faces.first;
//       final imageBytes = await imageFile.readAsBytes();
//       final decodedImage = img.decodeImage(imageBytes);

//       if (decodedImage != null) {
//         final cheekX = (face.boundingBox.left + face.boundingBox.right) ~/ 2;
//         final cheekY = (face.boundingBox.top + 3 * face.boundingBox.bottom) ~/ 4;

//         final cheekPixel = decodedImage.getPixel(cheekX, cheekY);
//         final r = img.getRed(cheekPixel);
//         final g = img.getGreen(cheekPixel);
//         final b = img.getBlue(cheekPixel);

//         final detectedColor = Color.fromRGBO(r, g, b, 1);
//         final luminance = detectedColor.computeLuminance();

//         if (luminance > 0.7) {
//           skinToneCategory = 'Fair';
//         } else if (luminance > 0.5) {
//           skinToneCategory = 'Light';
//         } else if (luminance > 0.3) {
//           skinToneCategory = 'Medium';
//         } else if (luminance > 0.15) {
//           skinToneCategory = 'Olive';
//         } else {
//           skinToneCategory = 'Dark';
//         }

//         setState(() {
//           this.detectedColor = detectedColor;
//           isValid = true;
//           recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//         });

//         await FirebaseAnalytics.instance.logEvent(
//           name: 'face_color_detected',
//           parameters: {
//             'r': r,
//             'g': g,
//             'b': b,
//             'skin_tone': skinToneCategory,
//           },
//         );
//       }
//     } else {
//       setState(() {
//         isValid = false;
//         recommendedColors = [];
//       });
//     }
//   }
//   List<Map<String, Color>> getRecommendedColors(String skinTone, String gender) {
//     switch (skinTone) {
//       case 'Fair':
//         return gender == 'Male' 
//           ? [
//               {'Navy Blue': Color(0xFF000080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Olive': Color(0xFF808000)},
//               {'Teal': Color(0xFF008080)},
//               {'Maroon': Color(0xFF800000)},
//               {'Slate Blue': Color(0xFF6A5ACD)},
//             ]
//           : [
//               {'Coral': Color(0xFFFF7F50)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint': Color(0xFF98FF98)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Mauve': Color(0xFFE0B0FF)},
//               {'Turquoise': Color(0xFF40E0D0)},
//             ];
//       case 'Light':
//         return gender == 'Male'
//           ? [
//               {'Dark Blue': Color(0xFF00008B)},
//               {'Maroon': Color(0xFF800000)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Slate Gray': Color(0xFF708090)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal': Color(0xFF36454F)},
//               {'Indigo': Color(0xFF4B0082)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Sage Green': Color(0xFFBCBFA3)},
//             ];
//       case 'Medium':
//         return gender == 'Male'
//           ? [
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Deep Red': Color(0xFF8B0000)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Dark Purple': Color(0xFF301934)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Olive': Color(0xFF808000)},
//               {'Navy': Color(0xFF000080)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Fuchsia': Color(0xFFFF00FF)},
//               {'Teal': Color(0xFF008080)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Magenta': Color(0xFF8B008B)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Olive':
//         return gender == 'Male'
//           ? [
//               {'Cream': Color(0xFFFFFDD0)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Navy': Color(0xFF000080)},
//               {'Sage Green': Color(0xFF9DC183)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Maroon': Color(0xFF800000)},
//               {'Forest Green': Color(0xFF228B22)},
//             ]
//           : [
//               {'Off-White': Color(0xFFFAF9F6)},
//               {'Terracotta': Color(0xFFE2725B)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Teal': Color(0xFF008080)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Dark':
//         return gender == 'Male'
//           ? [
//               {'White': Color(0xFFFFFFFF)},
//               {'Light Gray': Color(0xFFD3D3D3)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Light Blue': Color(0xFFADD8E6)},
//               {'Pastel Orange': Color(0xFFFFB347)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Cream': Color(0xFFFFFDD0)},
//             ]
//           : [
//               {'Ivory': Color(0xFFFFFFF0)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Light Pink': Color(0xFFFFB6C1)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//             ];
//       default:
//         return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Clothing Color Recommender')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Column(
//                     children: [
//                       CameraPreview(_controller),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final image = await _controller.takePicture();
//                           setState(() {
//                             _image = File(image.path);
//                           });
//                           await detectFaceColor(_image!);
//                           await _uploadFileToFirebase(_image!);
//                         },
//                         child: Text('Analyze Face Color'),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!, height: 200),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Pick Image from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//             SizedBox(height: 20),
//             DropdownButton<String>(
//               value: selectedGender,
//               items: <String>['Male', 'Female'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedGender = newValue!;
//                   if (isValid) {
//                     recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//                   }
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (isValid)
//               Column(
//                 children: [
//                   Text('Detected Face Color:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Container(
//                     width: 100,
//                     height: 100,
//                     color: detectedColor,
//                   ),
//                   SizedBox(height: 10),
//                   Text('Skin Tone Category: $skinToneCategory', style: TextStyle(fontSize: 16)),
//                   SizedBox(height: 20),
//                   Text('Recommended Clothing Colors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: recommendedColors.map((colorMap) => 
//                       Container(
//                         width: 100,
//                         height: 100,
//                         color: colorMap.values.first,
//                         child: Center(
//                           child: Text(
//                             colorMap.keys.first,
//                             style: TextStyle(
//                               color: colorMap.values.first.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//                               fontSize: 12,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     ).toList(),
//                   ),
//                 ],
//               )
//             else
//               Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class ClothingColorRecommender extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ClothingColorRecommender({required this.cameras});

//   @override
//   _ClothingColorRecommenderState createState() => _ClothingColorRecommenderState();
// }

// class _ClothingColorRecommenderState extends State<ClothingColorRecommender> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   Color detectedColor = Colors.white;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableClassification: false,
//       enableLandmarks: true,
//       enableTracking: false,
//       performanceMode: FaceDetectorMode.fast,
//     ),
//   );
//   bool isValid = false;
//   List<Map<String, Color>> recommendedColors = [];
//   String selectedGender = 'Male';
//   String skinToneCategory = 'Medium';

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }

//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path);
//         });

//         await _uploadFileToFirebase(_image!);
//         await detectFaceColor(_image!);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       _showNotification('Error picking image', isError: true);
//     }
//   }

//   Future<void> _uploadFileToFirebase(File file) async {
//     try {
//       String storagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpeg';
//       Reference ref = _storage.ref().child(storagePath);
//       UploadTask uploadTask = ref.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
//       }, onError: (e) {
//         print('Error during upload: $e');
//         _showNotification('Error uploading image', isError: true);
//       }, onDone: () async {
//         String downloadURL = await ref.getDownloadURL();
//         print('File uploaded. Download URL: $downloadURL');
//         _showNotification('Image uploaded successfully');
//       });

//       await uploadTask;
//     } catch (e) {
//       print("Error uploading file: $e");
//       _showNotification('Error uploading image', isError: true);
//     }
//   }

//   void _showNotification(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> detectFaceColor(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final faces = await _faceDetector.processImage(inputImage);

//     if (faces.isNotEmpty) {
//       final face = faces.first;
//       final imageBytes = await imageFile.readAsBytes();
//       final decodedImage = img.decodeImage(imageBytes);

//       if (decodedImage != null) {
//         final cheekX = (face.boundingBox.left + face.boundingBox.right) ~/ 2;
//         final cheekY = (face.boundingBox.top + 3 * face.boundingBox.bottom) ~/ 4;

//         final cheekPixel = decodedImage.getPixel(cheekX, cheekY);
//         final r = img.getRed(cheekPixel);
//         final g = img.getGreen(cheekPixel);
//         final b = img.getBlue(cheekPixel);

//         final detectedColor = Color.fromRGBO(r, g, b, 1);
//         final luminance = detectedColor.computeLuminance();

//         if (luminance > 0.7) {
//           skinToneCategory = 'Fair';
//         } else if (luminance > 0.5) {
//           skinToneCategory = 'Light';
//         } else if (luminance > 0.3) {
//           skinToneCategory = 'Medium';
//         } else if (luminance > 0.15) {
//           skinToneCategory = 'Olive';
//         } else {
//           skinToneCategory = 'Dark';
//         }

//         setState(() {
//           this.detectedColor = detectedColor;
//           isValid = true;
//           recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//         });

//         await FirebaseAnalytics.instance.logEvent(
//           name: 'face_color_detected',
//           parameters: {
//             'r': r,
//             'g': g,
//             'b': b,
//             'skin_tone': skinToneCategory,
//           },
//         );
//       }
//     } else {
//       setState(() {
//         isValid = false;
//         recommendedColors = [];
//       });
//     }
//   }

//   List<Map<String, Color>> getRecommendedColors(String skinTone, String gender) {
//     switch (skinTone) {
//       case 'Fair':
//         return gender == 'Male' 
//           ? [
//               {'Navy Blue': Color(0xFF000080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Olive': Color(0xFF808000)},
//               {'Teal': Color(0xFF008080)},
//               {'Maroon': Color(0xFF800000)},
//               {'Slate Blue': Color(0xFF6A5ACD)},
//             ]
//           : [
//               {'Coral': Color(0xFFFF7F50)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint': Color(0xFF98FF98)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Mauve': Color(0xFFE0B0FF)},
//               {'Turquoise': Color(0xFF40E0D0)},
//             ];
//       case 'Light':
//         return gender == 'Male'
//           ? [
//               {'Dark Blue': Color(0xFF00008B)},
//               {'Maroon': Color(0xFF800000)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Slate Gray': Color(0xFF708090)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal': Color(0xFF36454F)},
//               {'Indigo': Color(0xFF4B0082)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Sage Green': Color(0xFFBCBFA3)},
//             ];
//       case 'Medium':
//         return gender == 'Male'
//           ? [
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Deep Red': Color(0xFF8B0000)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Dark Purple': Color(0xFF301934)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Olive': Color(0xFF808000)},
//               {'Navy': Color(0xFF000080)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Fuchsia': Color(0xFFFF00FF)},
//               {'Teal': Color(0xFF008080)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Magenta': Color(0xFF8B008B)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Olive':
//         return gender == 'Male'
//           ? [
//               {'Cream': Color(0xFFFFFDD0)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Navy': Color(0xFF000080)},
//               {'Sage Green': Color(0xFF9DC183)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Maroon': Color(0xFF800000)},
//               {'Forest Green': Color(0xFF228B22)},
//             ]
//           : [
//               {'Off-White': Color(0xFFFAF9F6)},
//               {'Terracotta': Color(0xFFE2725B)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Teal': Color(0xFF008080)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Dark':
//         return gender == 'Male'
//           ? [
//               {'White': Color(0xFFFFFFFF)},
//               {'Light Gray': Color(0xFFD3D3D3)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Light Blue': Color(0xFFADD8E6)},
//               {'Pastel Orange': Color(0xFFFFB347)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Cream': Color(0xFFFFFDD0)},
//             ]
//           : [
//               {'Ivory': Color(0xFFFFFFF0)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Light Pink': Color(0xFFFFB6C1)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//             ];
//       default:
//         return [];
//     }
// //   }
//     // The getRecommendedColors function remains the same as in your original code
//     // I'm omitting it here for brevity, but make sure to include it in your actual file
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Clothing Color Recommender')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Column(
//                     children: [
//                       CameraPreview(_controller),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final image = await _controller.takePicture();
//                           setState(() {
//                             _image = File(image.path);
//                           });
//                           await detectFaceColor(_image!);
//                           await _uploadFileToFirebase(_image!);
//                         },
//                         child: Text('Analyze Face Color'),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!, height: 200),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Pick Image from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//             SizedBox(height: 20),
//             DropdownButton<String>(
//               value: selectedGender,
//               items: <String>['Male', 'Female'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedGender = newValue!;
//                   if (isValid) {
//                     recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//                   }
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (isValid)
//               Column(
//                 children: [
//                   Text('Detected Face Color:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Container(
//                     width: 100,
//                     height: 100,
//                     color: detectedColor,
//                   ),
//                   SizedBox(height: 10),
//                   Text('Skin Tone Category: $skinToneCategory', style: TextStyle(fontSize: 16)),
//                   SizedBox(height: 20),
//                   Text('Recommended Clothing Colors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: recommendedColors.map((colorMap) => 
//                       Container(
//                         width: 100,
//                         height: 100,
//                         color: colorMap.values.first,
//                         child: Center(
//                           child: Text(
//                             colorMap.keys.first,
//                             style: TextStyle(
//                               color: colorMap.values.first.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//                               fontSize: 12,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     ).toList(),
//                   ),
//                 ],
//               )
//             else
//               Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// } 

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class ClothingColorRecommender extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ClothingColorRecommender({required this.cameras});

//   @override
//   _ClothingColorRecommenderState createState() => _ClothingColorRecommenderState();
// }

// class _ClothingColorRecommenderState extends State<ClothingColorRecommender> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   Color detectedColor = Colors.white;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableClassification: false,
//       enableLandmarks: true,
//       enableTracking: false,
//       performanceMode: FaceDetectorMode.fast,
//     ),
//   );
//   bool isValid = false;
//   List<Map<String, Color>> recommendedColors = [];
//   String selectedGender = 'Male';
//   String skinToneCategory = 'Medium';

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }

//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path);
//         });

//         await _uploadFileToFirebase(_image!);
//         await detectFaceColor(_image!);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       _showNotification('Error picking image', isError: true);
//     }
//   }

//   Future<void> _uploadFileToFirebase(File file) async {
//     try {
//       String storagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpeg';
//       Reference ref = _storage.ref().child(storagePath);
//       UploadTask uploadTask = ref.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
//       }, onError: (e) {
//         print('Error during upload: $e');
//         _showNotification('Error uploading image', isError: true);
//       }, onDone: () async {
//         String downloadURL = await ref.getDownloadURL();
//         print('File uploaded. Download URL: $downloadURL');
//         _showNotification('Image uploaded successfully');
//       });

//       await uploadTask;
//     } catch (e) {
//       print("Error uploading file: $e");
//       _showNotification('Error uploading image', isError: true);
//     }
//   }

//   void _showNotification(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : Colors.green,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   Future<void> detectFaceColor(File imageFile) async {
//     final inputImage = InputImage.fromFile(imageFile);
//     final faces = await _faceDetector.processImage(inputImage);

//     if (faces.isNotEmpty) {
//       final face = faces.first;
//       final imageBytes = await imageFile.readAsBytes();
//       final decodedImage = img.decodeImage(imageBytes);

//       if (decodedImage != null) {
//         final cheekX = (face.boundingBox.left + face.boundingBox.right) ~/ 2;
//         final cheekY = (face.boundingBox.top + 3 * face.boundingBox.bottom) ~/ 4;

//         final cheekPixel = decodedImage.getPixel(cheekX, cheekY);
//         final r = img.getRed(cheekPixel);
//         final g = img.getGreen(cheekPixel);
//         final b = img.getBlue(cheekPixel);

//         final detectedColor = Color.fromRGBO(r, g, b, 1);
//         final luminance = detectedColor.computeLuminance();

//         if (luminance > 0.7) {
//           skinToneCategory = 'Fair';
//         } else if (luminance > 0.5) {
//           skinToneCategory = 'Light';
//         } else if (luminance > 0.3) {
//           skinToneCategory = 'Medium';
//         } else if (luminance > 0.15) {
//           skinToneCategory = 'Olive';
//         } else {
//           skinToneCategory = 'Dark';
//         }

//         setState(() {
//           this.detectedColor = detectedColor;
//           isValid = true;
//           recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//         });

//         await FirebaseAnalytics.instance.logEvent(
//           name: 'face_color_detected',
//           parameters: {
//             'r': r,
//             'g': g,
//             'b': b,
//             'skin_tone': skinToneCategory,
//           },
//         );
//       }
//     } else {
//       setState(() {
//         isValid = false;
//         recommendedColors = [];
//       });
//     }
//   }

//   List<Map<String, Color>> getRecommendedColors(String skinTone, String gender) {
//     switch (skinTone) {
//       case 'Fair':
//         return gender == 'Male' 
//           ? [
//               {'Navy Blue': Color(0xFF000080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Olive': Color(0xFF808000)},
//               {'Teal': Color(0xFF008080)},
//               {'Maroon': Color(0xFF800000)},
//               {'Slate Blue': Color(0xFF6A5ACD)},
//             ]
//           : [
//               {'Coral': Color(0xFFFF7F50)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint': Color(0xFF98FF98)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Mauve': Color(0xFFE0B0FF)},
//               {'Turquoise': Color(0xFF40E0D0)},
//             ];
//       case 'Light':
//         return gender == 'Male'
//           ? [
//               {'Dark Blue': Color(0xFF00008B)},
//               {'Maroon': Color(0xFF800000)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Slate Gray': Color(0xFF708090)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal': Color(0xFF36454F)},
//               {'Indigo': Color(0xFF4B0082)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Soft Pink': Color(0xFFFFB6C1)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//               {'Sage Green': Color(0xFFBCBFA3)},
//             ];
//       case 'Medium':
//         return gender == 'Male'
//           ? [
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Deep Red': Color(0xFF8B0000)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Dark Purple': Color(0xFF301934)},
//               {'Forest Green': Color(0xFF228B22)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Olive': Color(0xFF808000)},
//               {'Navy': Color(0xFF000080)},
//               {'Rust': Color(0xFFB7410E)},
//             ]
//           : [
//               {'Fuchsia': Color(0xFFFF00FF)},
//               {'Teal': Color(0xFF008080)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Magenta': Color(0xFF8B008B)},
//               {'Emerald Green': Color(0xFF50C878)},
//               {'Royal Blue': Color(0xFF4169E1)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Olive':
//         return gender == 'Male'
//           ? [
//               {'Cream': Color(0xFFFFFDD0)},
//               {'Rust': Color(0xFFB7410E)},
//               {'Navy': Color(0xFF000080)},
//               {'Sage Green': Color(0xFF9DC183)},
//               {'Burgundy': Color(0xFF800020)},
//               {'Charcoal Gray': Color(0xFF36454F)},
//               {'Deep Teal': Color(0xFF008080)},
//               {'Khaki': Color(0xFFC3B091)},
//               {'Maroon': Color(0xFF800000)},
//               {'Forest Green': Color(0xFF228B22)},
//             ]
//           : [
//               {'Off-White': Color(0xFFFAF9F6)},
//               {'Terracotta': Color(0xFFE2725B)},
//               {'Deep Purple': Color(0xFF301934)},
//               {'Olive Green': Color(0xFF556B2F)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Teal': Color(0xFF008080)},
//               {'Plum': Color(0xFF8E4585)},
//               {'Gold': Color(0xFFFFD700)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Mauve': Color(0xFFE0B0FF)},
//             ];
//       case 'Dark':
//         return gender == 'Male'
//           ? [
//               {'White': Color(0xFFFFFFFF)},
//               {'Light Gray': Color(0xFFD3D3D3)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Light Blue': Color(0xFFADD8E6)},
//               {'Pastel Orange': Color(0xFFFFB347)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Cream': Color(0xFFFFFDD0)},
//             ]
//           : [
//               {'Ivory': Color(0xFFFFFFF0)},
//               {'Peach': Color(0xFFFFE5B4)},
//               {'Mint Green': Color(0xFF98FF98)},
//               {'Lavender': Color(0xFFE6E6FA)},
//               {'Light Pink': Color(0xFFFFB6C1)},
//               {'Pale Yellow': Color(0xFFFFFFE0)},
//               {'Sky Blue': Color(0xFF87CEEB)},
//               {'Coral': Color(0xFFFF7F50)},
//               {'Turquoise': Color(0xFF40E0D0)},
//               {'Periwinkle': Color(0xFFCCCCFF)},
//             ];
//       default:
//         return [];
//     }
// //   }
//     // The getRecommendedColors function remains the same as in your original code
//     // I'm omitting it here for brevity, but make sure to include it in your actual file
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Clothing Color Recommender')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Column(
//                     children: [
//                       CameraPreview(_controller),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final image = await _controller.takePicture();
//                           setState(() {
//                             _image = File(image.path);
//                           });
//                           await detectFaceColor(_image!);
//                           await _uploadFileToFirebase(_image!);
//                         },
//                         child: Text('Analyze Face Color'),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!, height: 200),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Pick Image from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//             SizedBox(height: 20),
//             DropdownButton<String>(
//               value: selectedGender,
//               items: <String>['Male', 'Female'].map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedGender = newValue!;
//                   if (isValid) {
//                     recommendedColors = getRecommendedColors(skinToneCategory, selectedGender);
//                   }
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (isValid)
//               Column(
//                 children: [
//                   Text('Detected Face Color:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   Container(
//                     width: 100,
//                     height: 100,
//                     color: detectedColor,
//                   ),
//                   SizedBox(height: 10),
//                   Text('Skin Tone Category: $skinToneCategory', style: TextStyle(fontSize: 16)),
//                   SizedBox(height: 20),
//                   Text('Recommended Clothing Colors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 10),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: recommendedColors.map((colorMap) => 
//                       ColorBox(
//                         colorName: colorMap.keys.first,
//                         color: colorMap.values.first,
//                       )
//                     ).toList(),
//                   ),
//                 ],
//               )
//             else
//               Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ColorBox extends StatefulWidget {
//   final String colorName;
//   final Color color;

//   ColorBox({required this.colorName, required this.color});

//   @override
//   _ColorBoxState createState() => _ColorBoxState();
// }

// class _ColorBoxState extends State<ColorBox> {
//   bool _isHovered = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => setState(() => _isHovered = true),
//       onTapUp: (_) => setState(() => _isHovered = false),
//       onTapCancel: () => setState(() => _isHovered = false),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         width: _isHovered ? 120 : 100,
//         height: _isHovered ? 120 : 100,
//         color: widget.color,
//         child: Center(
//           child: Text(
//             widget.colorName,
//             style: TextStyle(
//               color: widget.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//               fontSize: _isHovered ? 14 : 12,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_analytics/firebase_analytics.dart';

enum ColorOption {
  Recommended,
  Check,
  Plan
}

class ClothingColorRecommender extends StatefulWidget {
  final List<CameraDescription> cameras;

  ClothingColorRecommender({required this.cameras});

  @override
  _ClothingColorRecommenderState createState() => _ClothingColorRecommenderState();
}

class _ClothingColorRecommenderState extends State<ClothingColorRecommender> {
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
  List<Map<String, Color>> recommendedColors = [];
  String selectedGender = 'Male';
  String skinToneCategory = 'Medium';
  ColorOption selectedColorOption = ColorOption.Recommended;

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

        final detectedColor = Color.fromRGBO(r, g, b, 1);
        final luminance = detectedColor.computeLuminance();

        if (luminance > 0.7) {
          skinToneCategory = 'Fair';
        } else if (luminance > 0.5) {
          skinToneCategory = 'Light';
        } else if (luminance > 0.3) {
          skinToneCategory = 'Medium';
        } else if (luminance > 0.15) {
          skinToneCategory = 'Olive';
        } else {
          skinToneCategory = 'Dark';
        }

        setState(() {
          this.detectedColor = detectedColor;
          isValid = true;
          recommendedColors = getRecommendedColors(skinToneCategory, selectedGender, selectedColorOption);
        });

        await FirebaseAnalytics.instance.logEvent(
          name: 'face_color_detected',
          parameters: {
            'r': r,
            'g': g,
            'b': b,
            'skin_tone': skinToneCategory,
          },
        );
      }
    } else {
      setState(() {
        isValid = false;
        recommendedColors = [];
      });
    }
  }

  List<Map<String, Color>> getRecommendedColors(String skinTone, String gender, [ColorOption option = ColorOption.Recommended]) {
    switch (option) {
      case ColorOption.Recommended:
        return _getRecommendedColors(skinTone, gender);
      case ColorOption.Check:
        return _getCheckColors();
      case ColorOption.Plan:
        return _getPlanColors();
      default:
        return [];
    }
  }

  List<Map<String, Color>> _getRecommendedColors(String skinTone, String gender) {
    switch (skinTone) {
      case 'Fair':
        return gender == 'Male' 
          ? [
              {'Navy Blue': Color(0xFF000080)},
              {'Burgundy': Color(0xFF800020)},
              {'Forest Green': Color(0xFF228B22)},
              {'Charcoal Gray': Color(0xFF36454F)},
              {'Deep Purple': Color(0xFF301934)},
              {'Rust': Color(0xFFB7410E)},
              {'Olive': Color(0xFF808000)},
              {'Teal': Color(0xFF008080)},
              {'Maroon': Color(0xFF800000)},
              {'Slate Blue': Color(0xFF6A5ACD)},
            ]
          : [
              {'Coral': Color(0xFFFF7F50)},
              {'Emerald Green': Color(0xFF50C878)},
              {'Royal Blue': Color(0xFF4169E1)},
              {'Lavender': Color(0xFFE6E6FA)},
              {'Soft Pink': Color(0xFFFFB6C1)},
              {'Peach': Color(0xFFFFE5B4)},
              {'Mint': Color(0xFF98FF98)},
              {'Periwinkle': Color(0xFFCCCCFF)},
              {'Mauve': Color(0xFFE0B0FF)},
              {'Turquoise': Color(0xFF40E0D0)},
            ];
      case 'Light':
        return gender == 'Male'
          ? [
              {'Dark Blue': Color(0xFF00008B)},
              {'Maroon': Color(0xFF800000)},
              {'Olive Green': Color(0xFF556B2F)},
              {'Slate Gray': Color(0xFF708090)},
              {'Deep Teal': Color(0xFF008080)},
              {'Burgundy': Color(0xFF800020)},
              {'Forest Green': Color(0xFF228B22)},
              {'Charcoal': Color(0xFF36454F)},
              {'Indigo': Color(0xFF4B0082)},
              {'Rust': Color(0xFFB7410E)},
            ]
          : [
              {'Turquoise': Color(0xFF40E0D0)},
              {'Plum': Color(0xFF8E4585)},
              {'Peach': Color(0xFFFFE5B4)},
              {'Sky Blue': Color(0xFF87CEEB)},
              {'Mint Green': Color(0xFF98FF98)},
              {'Coral': Color(0xFFFF7F50)},
              {'Lavender': Color(0xFFE6E6FA)},
              {'Soft Pink': Color(0xFFFFB6C1)},
              {'Periwinkle': Color(0xFFCCCCFF)},
              {'Sage Green': Color(0xFFBCBFA3)},
            ];
      case 'Medium':
        return gender == 'Male'
          ? [
              {'Royal Blue': Color(0xFF4169E1)},
              {'Deep Red': Color(0xFF8B0000)},
              {'Khaki': Color(0xFFC3B091)},
              {'Dark Purple': Color(0xFF301934)},
              {'Forest Green': Color(0xFF228B22)},
              {'Charcoal Gray': Color(0xFF36454F)},
              {'Burgundy': Color(0xFF800020)},
              {'Olive': Color(0xFF808000)},
              {'Navy': Color(0xFF000080)},
              {'Rust': Color(0xFFB7410E)},
            ]
          : [
              {'Fuchsia': Color(0xFFFF00FF)},
              {'Teal': Color(0xFF008080)},
              {'Coral': Color(0xFFFF7F50)},
              {'Gold': Color(0xFFFFD700)},
              {'Magenta': Color(0xFF8B008B)},
              {'Emerald Green': Color(0xFF50C878)},
              {'Royal Blue': Color(0xFF4169E1)},
              {'Plum': Color(0xFF8E4585)},
              {'Turquoise': Color(0xFF40E0D0)},
              {'Mauve': Color(0xFFE0B0FF)},
            ];
      case 'Olive':
        return gender == 'Male'
          ? [
              {'Cream': Color(0xFFFFFDD0)},
              {'Rust': Color(0xFFB7410E)},
              {'Navy': Color(0xFF000080)},
              {'Sage Green': Color(0xFF9DC183)},
              {'Burgundy': Color(0xFF800020)},
              {'Charcoal Gray': Color(0xFF36454F)},
              {'Deep Teal': Color(0xFF008080)},
              {'Khaki': Color(0xFFC3B091)},
              {'Maroon': Color(0xFF800000)},
              {'Forest Green': Color(0xFF228B22)},
            ]
          : [
              {'Off-White': Color(0xFFFAF9F6)},
              {'Terracotta': Color(0xFFE2725B)},
              {'Deep Purple': Color(0xFF301934)},
              {'Olive Green': Color(0xFF556B2F)},
              {'Coral': Color(0xFFFF7F50)},
              {'Teal': Color(0xFF008080)},
              {'Plum': Color(0xFF8E4585)},
              {'Gold': Color(0xFFFFD700)},
              {'Turquoise': Color(0xFF40E0D0)},
              {'Mauve': Color(0xFFE0B0FF)},
            ];
      case 'Dark':
        return gender == 'Male'
          ? [
              {'White': Color(0xFFFFFFFF)},
              {'Light Gray': Color(0xFFD3D3D3)},
              {'Pale Yellow': Color(0xFFFFFFE0)},
              {'Light Blue': Color(0xFFADD8E6)},
              {'Pastel Orange': Color(0xFFFFB347)},
              {'Mint Green': Color(0xFF98FF98)},
              {'Lavender': Color(0xFFE6E6FA)},
              {'Peach': Color(0xFFFFE5B4)},
              {'Sky Blue': Color(0xFF87CEEB)},
              {'Cream': Color(0xFFFFFDD0)},
            ]
          : [
              {'Ivory': Color(0xFFFFFFF0)},
              {'Peach': Color(0xFFFFE5B4)},
              {'Mint Green': Color(0xFF98FF98)},
              {'Lavender': Color(0xFFE6E6FA)},
              {'Light Pink': Color(0xFFFFB6C1)},
              {'Pale Yellow': Color(0xFFFFFFE0)},
              {'Sky Blue': Color(0xFF87CEEB)},
              {'Coral': Color(0xFFFF7F50)},
              {'Turquoise': Color(0xFF40E0D0)},
              {'Periwinkle': Color(0xFFCCCCFF)},
            ];
      default:
        return [];
    }
  }

  List<Map<String, Color>> _getCheckColors() {
    return [
      {'Black': Color(0xFF000000)},
      {'White': Color(0xFFFFFFFF)},
      {'Red': Color(0xFFFF0000)},
      {'Green': Color(0xFF00FF00)},
      {'Blue': Color(0xFF0000FF)},
      {'Yellow': Color(0xFFFFFF00)},
      {'Cyan': Color(0xFF00FFFF)},
      {'Magenta': Color(0xFFFF00FF)},
    ];
  }

  List<Map<String, Color>> _getPlanColors() {
    return [
      {'Light Gray': Color(0xFFD3D3D3)},
      {'Beige': Color(0xFFF5F5DC)},
      {'Ivory': Color(0xFFFFFFF0)},
      {'Cream': Color(0xFFFFFDD0)},
      {'Pale Yellow': Color(0xFFFFFFE0)},
      {'Light Blue': Color(0xFFADD8E6)},
      {'Mint Green': Color(0xFF98FF98)},
      {'Lavender': Color(0xFFE6E6FA)},
    ];
  }

  bool checkColor(Color color, String name) {
    switch (name.toLowerCase()) {
      case 'black':
        return color.value == 0xFF000000;
      case 'white':
        return color.value == 0xFFFFFFFF;
      case 'red':
        return color.value == 0xFFFF0000;
      case 'green':
        return color.value == 0xFF00FF00;
      case 'blue':
        return color.value == 0xFF0000FF;
      case 'yellow':
        return color.value == 0xFFFFFF00;
      case 'cyan':
        return color.value == 0xFF00FFF00;
        default:
        return false;
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Clothing Color Recommender')),
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
                      child: Text('Analyze Face Color'),
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
          DropdownButton<String>(
            value: selectedGender,
            items: <String>['Male', 'Female'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue!;
                if (isValid) {
                  recommendedColors = getRecommendedColors(skinToneCategory, selectedGender, selectedColorOption);
                }
              });
            },
          ),
          SizedBox(height: 20),
          DropdownButton<ColorOption>(
            value: selectedColorOption,
            items: ColorOption.values.map((ColorOption option) {
              return DropdownMenuItem<ColorOption>(
                value: option,
                child: Text(option.toString().split('.').last),
              );
            }).toList(),
            onChanged: (ColorOption? newValue) {
              setState(() {
                selectedColorOption = newValue!;
                if (isValid) {
                  recommendedColors = getRecommendedColors(skinToneCategory, selectedGender, selectedColorOption);
                }
              });
            },
          ),
          SizedBox(height: 20),
          if (isValid)
            Column(
              children: [
                Text('Detected Face Color:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  width: 100,
                  height: 100,
                  color: detectedColor,
                ),
                SizedBox(height: 10),
                Text('Skin Tone Category: $skinToneCategory', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Text('${selectedColorOption.toString().split('.').last} Colors:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: recommendedColors.map((colorMap) => 
                    ColorBox(
                      colorName: colorMap.keys.first,
                      color: colorMap.values.first,
                    )
                  ).toList(),
                ),
              ],
            )
          else
            Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
        ],
      ),
    ),
  );
}
}
class ColorBox extends StatefulWidget {
  final String colorName;
  final Color color;

  ColorBox({required this.colorName, required this.color});

  @override
  _ColorBoxState createState() => _ColorBoxState();
}

class _ColorBoxState extends State<ColorBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _isHovered ? 120 : 100,
        height: _isHovered ? 120 : 100,
        color: widget.color,
        child: Center(
          child: Text(
            widget.colorName,
            style: TextStyle(
              color: widget.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontSize: _isHovered ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}  


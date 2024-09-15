// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());

// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   File? _image; // Variable to hold the selected image file
//   final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker
//   final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

//   // Method to pick an image from gallery or capture using camera
//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path); // Set the picked image file
//         });

//         // Upload the image to Firebase Storage
//         await _uploadFileToFirebase(_image!);
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   // Method to upload the selected image file to Firebase Storage
//   Future<void> _uploadFileToFirebase(File file) async {
//     try {
//       String storagePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpeg';
//       Reference ref = _storage.ref().child(storagePath);
//       UploadTask uploadTask = ref.putFile(file);

//       // Optional: Listen to state changes, errors, and completion of the upload task
//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         print('Upload progress: ${snapshot.bytesTransferred} / ${snapshot.totalBytes}');
//       }, onError: (e) {
//         print('Error during upload: $e');
//       }, onDone: () async {
//         String downloadURL = await ref.getDownloadURL();
//         print('File uploaded. Download URL: $downloadURL');
//       });

//       // Wait for the upload task to complete
//       await uploadTask;
//     } catch (e) {
//       print("Error uploading file: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker & Firebase Storage Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Camera Access', // Add the heading
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20), // Add some spacing after the heading
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _getImage(ImageSource.gallery);
//               },
//               child: Text('Pick Image from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _getImage(ImageSource.camera);
//               },
//               child: Text('Take Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> _getImage(ImageSource source) async {
//     try {
//       final pickedFile = await _picker.pickImage(source: source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = File(pickedFile.path);
//         });

//         await _uploadFileToFirebase(_image!);
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker & Firebase Storage Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Camera Access',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Pick Image from Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//-
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ColorDetectorScreen(cameras: cameras),
//     );
//   }
// }

// class ColorDetectorScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ColorDetectorScreen({required this.cameras});

//   @override
//   _ColorDetectorScreenState createState() => _ColorDetectorScreenState();
// }

// class _ColorDetectorScreenState extends State<ColorDetectorScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   Color detectedColor = Colors.white;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
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
//         await detectColorFromImage(_image!);
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

//   Future<void> detectColorFromImage(File imageFile) async {
//     final imageBytes = await imageFile.readAsBytes();
//     final decodedImage = img.decodeImage(imageBytes);

//     if (decodedImage != null) {
//       final centerPixel = decodedImage.getPixel(decodedImage.width ~/ 2, decodedImage.height ~/ 2);
//       final r = img.getRed(centerPixel);
//       final g = img.getGreen(centerPixel);
//       final b = img.getBlue(centerPixel);

//       setState(() {
//         detectedColor = Color.fromRGBO(r, g, b, 1);
//       });

//       // Compare with Pantone 53-3C
//       final pantone53_3C = Color(0xFF9B2335);
//       final colorDifference = calculateColorDifference(detectedColor, pantone53_3C);

//       // Log to Firebase Analytics
//       await FirebaseAnalytics.instance.logEvent(
//         name: 'color_detected',
//         parameters: {
//           'r': r,
//           'g': g,
//           'b': b,
//           'difference_from_pantone': colorDifference,
//         },
//       );
//     }
//   }

//   double calculateColorDifference(Color c1, Color c2) {
//     return (((c1.red - c2.red) * (c1.red - c2.red) +
//             (c1.green - c2.green) * (c1.green - c2.green) +
//             (c1.blue - c2.blue) * (c1.blue - c2.blue)) /
//         (3 * 255 * 255));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Color Detector')),
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
//                           await detectColorFromImage(_image!);
//                           await _uploadFileToFirebase(_image!);
//                         },
//                         child: Text('Detect Color'),
//                       ),
//                     ],
//                   );
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               },
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Camera Access',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
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
//             Container(
//               width: 100,
//               height: 100,
//               color: detectedColor,
//             ),
//             Text('Detected Color: ${detectedColor.toString()}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FaceColorDetectorScreen(cameras: cameras),
//     );
//   }
// }

// class FaceColorDetectorScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   FaceColorDetectorScreen({required this.cameras});

//   @override
//   _FaceColorDetectorScreenState createState() => _FaceColorDetectorScreenState();
// }

// class _FaceColorDetectorScreenState extends State<FaceColorDetectorScreen> {
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
//         // Sample color from the cheek area (adjust these values as needed)
//         final cheekX = (face.boundingBox.left + face.boundingBox.right) ~/ 2;
//         final cheekY = (face.boundingBox.top + 3 * face.boundingBox.bottom) ~/ 4;

//         final cheekPixel = decodedImage.getPixel(cheekX, cheekY);
//         final r = img.getRed(cheekPixel);
//         final g = img.getGreen(cheekPixel);
//         final b = img.getBlue(cheekPixel);

//         setState(() {
//           detectedColor = Color.fromRGBO(r, g, b, 1);
//           isValid = true;
//         });

//         // Log to Firebase Analytics
//         await FirebaseAnalytics.instance.logEvent(
//           name: 'face_color_detected',
//           parameters: {
//             'r': r,
//             'g': g,
//             'b': b,
//           },
//         );
//       }
//     } else {
//       setState(() {
//         isValid = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Face Color Detector')),
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
//                         child: Text('Detect Face Color'),
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
//             isValid
//                 ? Column(
//                     children: [
//                       Container(
//                         width: 100,
//                         height: 100,
//                         color: detectedColor,
//                       ),
//                       Text('Detected Face Color: ${detectedColor.toString()}'),
//                     ],
//                   )
//                 : Text('Invalid: No face detected', style: TextStyle(color: Colors.red, fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FaceColorDetectorScreen(cameras: cameras),
//     );
//   }
// }

// class FaceColorDetectorScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   FaceColorDetectorScreen({required this.cameras});

//   @override
//   _FaceColorDetectorScreenState createState() => _FaceColorDetectorScreenState();
// }

// class _FaceColorDetectorScreenState extends State<FaceColorDetectorScreen> {
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
//       appBar: AppBar(title: Text('Face Color Analyzer')),
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
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         scaffoldBackgroundColor: Colors.lightBlue[50],
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ClothingRecommenderScreen(cameras: cameras),
//     );
//   }
// }

// class ClothingRecommenderScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ClothingRecommenderScreen({required this.cameras});

//   @override
//   _ClothingRecommenderScreenState createState() => _ClothingRecommenderScreenState();
// }

// class _ClothingRecommenderScreenState extends State<ClothingRecommenderScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   String selectedGender = 'Male';
//   String selectedSkinTone = 'Medium';
//   List<Map<String, Color>> recommendedColors = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
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
//         _updateRecommendations();
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

//   void _updateRecommendations() {
//     setState(() {
//       recommendedColors = getRecommendedColors(selectedSkinTone, selectedGender);
//     });

//     FirebaseAnalytics.instance.logEvent(
//       name: 'recommendations_updated',
//       parameters: {
//         'gender': selectedGender,
//         'skin_tone': selectedSkinTone,
//       },
//     );
//   }

//   List<Map<String, Color>> getRecommendedColors(String skinTone, String gender) {
//     switch (skinTone) {
//       case 'Fair':
//   return gender == 'Male'
//     ?   [
//         {'Navy Blue': Color(0xFF000080)},
//         {'Burgundy': Color(0xFF800020)},
//         {'Forest Green': Color(0xFF228B22)},
//         {'Charcoal Gray': Color(0xFF36454F)},
//         {'Deep Purple': Color(0xFF301934)},
//         {'Rust': Color(0xFFB7410E)},
//         {'Olive': Color(0xFF808000)},
//         {'Teal': Color(0xFF008080)},
//         {'Maroon': Color(0xFF800000)},
//         {'Slate Blue': Color(0xFF6A5ACD)},
//           ]

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
//       appBar: AppBar(
//         title: Text('Style Advisor'),
//         backgroundColor: Colors.purple[400],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple[100]!, Colors.blue[100]!],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Card(
//                   color: Colors.white.withOpacity(0.9),
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   child: Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Column(
//                       children: [
//                         Text('Select Your Gender', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         DropdownButton<String>(
//                           value: selectedGender,
//                           isExpanded: true,
//                           items: <String>['Male', 'Female'].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedGender = newValue!;
//                               _updateRecommendations();
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Card(
//                   color: Colors.white.withOpacity(0.9),
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   child: Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Column(
//                       children: [
//                         Text('Select Your Skin Tone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         DropdownButton<String>(
//                           value: selectedSkinTone,
//                           isExpanded: true,
//                           items: <String>['Fair', 'Light', 'Medium', 'Olive', 'Dark'].map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               selectedSkinTone = newValue!;
//                               _updateRecommendations();
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.camera_alt),
//                   label: Text('Take Picture'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange[300],
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   onPressed: () => _getImage(ImageSource.camera),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.photo_library),
//                   label: Text('Pick Image from Gallery'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green[300],
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   ),
//                   onPressed: () => _getImage(ImageSource.gallery),
//                 ),
//                 SizedBox(height: 20),
//                 if (_image != null)
//                   Card(
//                     color: Colors.white.withOpacity(0.9),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           Text('Selected Image', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 10),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.file(_image!, height: 200, fit: BoxFit.cover),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 20),
//                 if (recommendedColors.isNotEmpty)
//                   Card(
//                     color: Colors.white.withOpacity(0.9),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           Text('Recommended Clothing Colors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 10),
//                           Wrap(
//                             spacing: 10,
//                             runSpacing: 10,
//                             children: recommendedColors.map((colorMap) =>
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                   color: colorMap.values.first,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     colorMap.keys.first,
//                                     style: TextStyle(
//                                       color: colorMap.values.first.computeLuminance() > 0.5 ? Colors.black : Colors.white,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               )
//                             ).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// File: clothe.dart

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FaceColorDetectorScreen(cameras: cameras),
//     );
//   }
// }

// class FaceColorDetectorScreen extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   FaceColorDetectorScreen({required this.cameras});

//   @override
//   _FaceColorDetectorScreenState createState() => _FaceColorDetectorScreenState();
// }

// class _FaceColorDetectorScreenState extends State<FaceColorDetectorScreen> {
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
//   return gender == 'Male'
//     ?   [
//         {'Navy Blue': Color(0xFF000080)},
//         {'Burgundy': Color(0xFF800020)},
//         {'Forest Green': Color(0xFF228B22)},
//         {'Charcoal Gray': Color(0xFF36454F)},
//         {'Deep Purple': Color(0xFF301934)},
//         {'Rust': Color(0xFFB7410E)},
//         {'Olive': Color(0xFF808000)},
//         {'Teal': Color(0xFF008080)},
//         {'Maroon': Color(0xFF800000)},
//         {'Slate Blue': Color(0xFF6A5ACD)},
//           ]

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
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//     // ... (keep the existing getRecommendedColors method)
//   }

//   @override
//   Widget build(BuildContext context) {
//     String skinToneCategory;
//     var recommendedColors;
//     var detectedColor;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Clothing Color Analyzer', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.teal,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 300,
//               child: FutureBuilder<void>(
//                 future: _initializeControllerFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return Stack(
//                       children: [
//                         CameraPreview(_controller),
//                         Positioned(
//                           bottom: 20,
//                           left: 0,
//                           right: 0,
//                           child: Center(
//                             child: ElevatedButton.icon(
//                               onPressed: () async {
//                                 final image = await _controller.takePicture();
//                                 setState(() {
//                                   _image = File(image.path);
//                                 });
//                                 await detectFaceColor(_image!);
//                                 await _uploadFileToFirebase(_image!);
//                               },
//                               icon: Icon(Icons.camera_alt),
//                               label: Text('Analyze Face'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.teal,
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             _image == null
//                 ? Text('No image selected.', style: TextStyle(fontSize: 16))
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Image.file(_image!, height: 200),
//                   ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => _getImage(ImageSource.gallery),
//                   icon: Icon(Icons.photo_library),
//                   label: Text('Gallery'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () => _getImage(ImageSource.camera),
//                   icon: Icon(Icons.camera_alt),
//                   label: Text('Camera'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepOrange,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Detected Skin Tone',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Container(
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: detectedColor,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.black, width: 2),
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Text(
//                           skinToneCategory,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Recommended Colors',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children: recommendedColors.map((colorMap) {
//                         String colorName = colorMap.keys.first;
//                         Color color = colorMap.values.first;
//                         return Tooltip(
//                           message: colorName,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: color,
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.black, width: 1),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   class _image {
//   }

//   class _controller {
//   }

//   class _initializeControllerFuture {
//   }

// File: colors.dart

// import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:firebase_analytics/firebase_analytics.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:image_picker/image_picker.dart';
// // import 'dart:io';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class ColorsPage extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   ColorsPage({required this.cameras});

//   @override
//   _ColorsPageState createState() => _ColorsPageState();
// }

// class _ColorsPageState extends State<ColorsPage> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
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
//   String selectedGender = 'Male';
//   String detectedSkinTone = 'Medium';
//   List<Map<String, Color>> recommendedColors = [];

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

//         setState(() {
//           if (luminance > 0.7) {
//             detectedSkinTone = 'Fair';
//           } else if (luminance > 0.5) {
//             detectedSkinTone = 'Light';
//           } else if (luminance > 0.3) {
//             detectedSkinTone = 'Medium';
//           } else if (luminance > 0.15) {
//             detectedSkinTone = 'Olive';
//           } else {
//             detectedSkinTone = 'Dark';
//           }
//           recommendedColors = getRecommendedColors(detectedSkinTone, selectedGender);
//         });

//         await FirebaseAnalytics.instance.logEvent(
//           name: 'face_color_detected',
//           parameters: {
//             'r': r,
//             'g': g,
//             'b': b,
//             'skin_tone': detectedSkinTone,
//           },
//         );
//       }
//     } else {
//       _showNotification('No face detected in the image', isError: true);
//     }
//   }

//   List<Map<String, Color>> getRecommendedColors(String skinTone, String gender) {
//     switch (skinTone) {
//       case 'Fair':
//   return gender == 'Male'
//     ?   [
//         {'Navy Blue': Color(0xFF000080)},
//         {'Burgundy': Color(0xFF800020)},
//         {'Forest Green': Color(0xFF228B22)},
//         {'Charcoal Gray': Color(0xFF36454F)},
//         {'Deep Purple': Color(0xFF301934)},
//         {'Rust': Color(0xFFB7410E)},
//         {'Olive': Color(0xFF808000)},
//         {'Teal': Color(0xFF008080)},
//         {'Maroon': Color(0xFF800000)},
//         {'Slate Blue': Color(0xFF6A5ACD)},
//           ]

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
//       appBar: AppBar(
//         title: Text('Color Recommendations'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Add your UI elements here
//             // For example:
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.camera),
//               child: Text('Take Picture'),
//             ),
//             ElevatedButton(
//               onPressed: () => _getImage(ImageSource.gallery),
//               child: Text('Choose from Gallery'),
//             ),
//             if (_image != null) Image.file(_image!),
//             Text('Detected Skin Tone: $detectedSkinTone'),
//             // Display recommended colors
//             // ...
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'face_color_detector_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   const MyApp({Key? key, required this.cameras}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Face Color Detector',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: FaceColorDetectorScreen(cameras: cameras),
//     );
//   }
// }

// import 'package:color_detector_app/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'cloth.dart';
// // import 'login.dart';
// // import 'forget_password.dart';
// // import 'signup.dart';
// import 'splash_screen.dart';
// import 'login_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }
// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   MyApp({required this.cameras});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/login',
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/login': (context) => LoginPage(),
//         '/main': (context) => MainPage(cameras: cameras),
//         // Add other routes as needed
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'face_color_detector_screen.dart';
// import 'splash_screen.dart';
// import 'home_page.dart';
// import 'main_page.dart';
// import 'about_page.dart';
// import 'splex.dart';  // Add this import
// import 'login_page.dart';
// // import 'login_page.dart';   // Add this import

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   const MyApp({Key? key, required this.cameras}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Face Color Detector',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/',  // Set the initial route
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/splex': (context) => SplexPage(),
//         '/login': (context) => LoginPage(),
//         '/home': (context) => HomePage(),
//         '/main': (context) => FaceColorDetectorScreen(cameras: cameras),
//         '/about': (context) => AboutPage(),
//         '/main_page': (context) => MainPage(),
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'face_color_detector_screen.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'splash_screen.dart';
// import 'home_page.dart';
// import 'main_page.dart';
// import 'about_page.dart';
// import 'splex.dart';
// import 'login_page.dart';
// import 'cloth.dart';
// // import 'clothes.dart';// Add this import

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   final cameras = await availableCameras();
//   runApp(MyApp(cameras: cameras));
// }

// class MyApp extends StatelessWidget {
//   final List<CameraDescription> cameras;

//   const MyApp({Key? key, required this.cameras}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Face Color Detector',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       initialRoute: '/',  // Set the initial route
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/splex': (context) => SplexPage(),
//         '/login': (context) => LoginPage(),
//         '/home': (context) => HomePage(),
//         '/main': (context) => FaceColorDetectorScreen(cameras: cameras),
//         '/about': (context) => AboutPage(),
//         '/main_page': (context) => MainPage(),
//         '/cloth': (context) => ClothingColorRecommender(cameras: cameras),
//       //   '/clothes': (context) => ClothingItem(id: 123); // Add this route
//        },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'login_page.dart';
// import 'signup_page.dart';
// import 'forgot_password_page.dart';
// import 'home_page.dart';
// import 'about_page.dart';
// import 'simple.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Initialize Firebase
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // Define your routes here
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Auth Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/login', // Set the initial route
//       routes: {
//         '/login': (context) => LoginPage(),
//         '/signup': (context) => SignupPage(),
//         '/forgot-password': (context) => ForgotPasswordPage(),
//         '/home': (context) => HomePage(),
//         '/about': (context) => AboutPage(),
//         '/simple': (context) => SimplePage(),
//         // Add other routes as needed
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'face_color_detector_screen.dart';
// import 'firebase_analytics.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'main_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'cloth.dart';
import 'simple.dart';
import 'fetchdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  // Initialize available cameras
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth & Camera Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set initial route to SplexPage (acts like splash screen)
      initialRoute: '/splex',
      routes: {
        '/splex': (context) => SplashScreen(), // Splash-like screen
        '/login': (context) => LoginPage(), // Login Page
        '/signup': (context) => SignupPage(), // Signup Page
        '/forgot-password': (context) =>
            ForgotPasswordPage(), // Forgot Password
        '/home': (context) => HomePage(), // Home Page
        '/about': (context) => AboutPage(), // About Page
        '/simple': (context) => SimplePage(), // Simple Page
        '/main': (context) =>
            FaceColorDetectorScreen(cameras: cameras), // Face detection
        '/main_page': (context) => MainPage(), // Main page for camera
        '/cloth': (context) => ClothingColorRecommender(
            cameras: cameras), // Clothing Color Recommender
        '/fetchdata': (context) => FetchDataPage(), // Page for fetching data
      },
    );
  }
}
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_mlkit_commons/google_mlkit_commons.dart';
//
// class FaceDetectionScreen extends StatefulWidget {
//   const FaceDetectionScreen({super.key});
//
//   @override
//   State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
// }
//
// class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
//   CameraController? _cameraController;
//   late FaceDetector _faceDetector;
//   bool _isDetecting = false;
//   List<Face> _faces = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initCameraAndDetector();
//   }
//
//   Future<void> _initCameraAndDetector() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Camera permission is required.')),
//       );
//       Navigator.pop(context);
//       return;
//     }
//
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//           (cam) => cam.lensDirection == CameraLensDirection.front,
//       orElse: () => cameras.first,
//     );
//
//     _cameraController = CameraController(
//       frontCamera,
//       ResolutionPreset.medium,
//       enableAudio: false,
//     );
//
//     await _cameraController!.initialize();
//
//     _faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//         enableContours: true,
//         enableLandmarks: true,
//       ),
//     );
//
//     _cameraController!.startImageStream((image) async {
//       if (_isDetecting) return;
//       _isDetecting = true;
//
//       try {
//         final inputImage = _processCameraImage(image, _cameraController!.description);
//         final faces = await _faceDetector.processImage(inputImage);
//         setState(() => _faces = faces);
//       } catch (e) {
//         print('Error detecting face: $e');
//       } finally {
//         _isDetecting = false;
//       }
//     });
//
//     setState(() {});
//   }
//
//   InputImage _processCameraImage(CameraImage image, CameraDescription camera) {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in image.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//
//     final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//
//     final imageRotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation)
//             ?? InputImageRotation.rotation0deg;
//
//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(image.format.raw)
//             ?? InputImageFormat.nv21;
//
//     final metadata = InputImageMetadata(
//       size: imageSize,
//       rotation: imageRotation,
//       format: inputImageFormat,
//       bytesPerRow: image.planes.first.bytesPerRow,
//     );
//
//     return InputImage.fromBytes(
//       bytes: bytes,
//       metadata: metadata,
//     );
//   }
//
//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Face Detection')),
//       body: _cameraController == null || !_cameraController!.value.isInitialized
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//         fit: StackFit.expand,
//         children: [
//           CameraPreview(_cameraController!),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               color: Colors.black54,
//               child: Text(
//                 'Detected Faces: ${_faces.length}',
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

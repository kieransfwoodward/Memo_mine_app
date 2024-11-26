// import 'dart:typed_data';
//
// import 'package:arkit_plugin/arkit_plugin.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:mine_app/main.dart';
// import 'package:vector_math/vector_math_64.dart';
// import 'package:vector_math/vector_math_64.dart' as vector;
//
//
// // class AugmentedReality extends StatefulWidget {
// //   AugmentedReality({Key? key}) : super(key: key);
// //   @override
// //   _AugmentedRealityState createState() => _AugmentedRealityState();
// // }
//
// class AugmentedReality extends StatelessWidget {
//
//
//   // receive data from the FirstScreen as a parameter
//   AugmentedReality({required this.url}) : super();
//
//
//   late ARKitController arkitController;
//   final String url;
//
//
//   @override
//   void dispose() {
//     arkitController.dispose();
//     //super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar:  AppBar(
//       centerTitle: true,
//       title: Text("Augmented Reality"),
//       backgroundColor: Color(0xFF005262),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(20),
//         ),
//       ),
//     ),
//     body: Container(
//       child: ARKitSceneView(
//         showFeaturePoints: false,
//         planeDetection: ARPlaneDetection.horizontal,
//         onARKitViewCreated: onARKitViewCreated,
//       ),
//     ),
//   );
//
//   void onARKitViewCreated(ARKitController arkitController) {
//    // ARKitReferenceNode? node;
//     this.arkitController = arkitController;
//   //  arkitController.addCoachingOverlay(CoachingOverlayGoal.horizontalPlane);
//
//     // void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
//     //   if (node != null) {
//     //     controller.remove(node!.name);
//     //   }
//     //   node = ARKitReferenceNode(
//     //     url: 'assets/PitRock_01.DAE',
//     //     scale: vector.Vector3.all(0.3),
//     //   );
//     //   controller.add(node!, parentNodeName: anchor.nodeName);
//     // }
//     //
//     // void _handleAddAnchor(ARKitAnchor anchor) {
//     //   if (anchor is ARKitPlaneAnchor) {
//     //     _addPlane(arkitController, anchor);
//     //   }
//     // }
//     //
//     //
//     // arkitController.onAddNodeForAnchor = _handleAddAnchor;
//
//
//
//
//     final material1 = ARKitMaterial(
//       lightingModelName: ARKitLightingModel.lambert,
//       diffuse: ARKitMaterialProperty.image("assets/images/background.jpeg"),
//
//     );
//     final sphere1 = ARKitBox(
//       materials: [material1],
//       width: 1,
//       height: 1,
//       length: 0.1,
//     );
//
//     final node2 = ARKitNode(
//       geometry: sphere1,
//       position: Vector3(0, 0, -0.5),
//       eulerAngles: Vector3.zero(),
//     );
//     this.arkitController.add(node2);
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//     final material = ARKitMaterial(
//       lightingModelName: ARKitLightingModel.lambert,
//       diffuse: ARKitMaterialProperty.image(url),
//
//     );
//     final sphere = ARKitBox(
//       materials: [material],
//       width: 0.5,
//       height: 0.5,
//       length: 0.5,
//     );
//
//     final node1 = ARKitNode(
//       geometry: sphere,
//       position: Vector3(0, 0, -0.5),
//       eulerAngles: Vector3.zero(),
//     );
//     this.arkitController.add(node1);
//
//     // timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
//     //   final rotation = node.eulerAngles;
//     //   rotation.x += 0.01;
//     //   node.eulerAngles = rotation;
//     // });
//   }
//
// }

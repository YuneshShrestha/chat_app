// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:rive/rive.dart';

// class RiveAnimationWidget extends StatefulWidget {
//   const RiveAnimationWidget({super.key});

//   @override
//   State<RiveAnimationWidget> createState() => _RiveAnimationWidgetState();
// }

// class _RiveAnimationWidgetState extends State<RiveAnimationWidget> {
//   RiveAnimationController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _loadRiveFile();
//   }

//   RiveFile? file;
//   void _loadRiveFile() async {
//     final bytes = await rootBundle.load('assets/teddy.riv');
//     file = RiveFile.import(bytes);
//     setState(() {
//       _controller = SimpleAnimation('isChecking');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null)
//       return Container(); // Placeholder until animation loads

//     return Rive(
//       artboard: file!.mainArtboard,
//       // animation: _controller,
//     );
//   }
// }

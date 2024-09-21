// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:d_art/view/modules/chatscreen/services/callservice.dart';

// class CallScreen extends StatefulWidget {
//   final String channelName;
//   final bool isVideo;

//   const CallScreen({
//     Key? key,
//     required this.channelName,
//     this.isVideo = true,
//   }) : super(key: key);

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   final CallService _callService = CallService();
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAgora();
//   }

//   Future<void> _initializeAgora() async {
//     await _callService.initAgoraRtcEngine();
//     await _callService.joinCall("D_ART PROJECT", isVideo: widget.isVideo);
//     setState(() {
//       _isInitialized = true;
//     });
//   }

//   @override
//   void dispose() {
//     _callService.endCall();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isVideo ? 'Video Call' : 'Audio Call'),
//       ),
//       body: _isInitialized
//           ? widget.isVideo
//               ? AgoraVideoView(
//                   controller: VideoViewController(
//                     rtcEngine: _callService.engine!,
//                     canvas: const VideoCanvas(uid: 0),
//                   ),
//                 )
//               : Center(child: Text('Audio Call in progress...'))
//           : Center(
//               child:
//                   CircularProgressIndicator()), // Show a loader until Agora is initialized
//     );
//   }
// }

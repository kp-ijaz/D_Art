import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect {
  chatListShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black.withOpacity(.2),
            ),
            title: Container(
              height: 15,
              color: Colors.black.withOpacity(.2),
            ),
            subtitle: Container(
              height: 5,
              color: Colors.black.withOpacity(.2),
            ),
          );
        },
      ),
    );
  }

  messageLoadShimmer(Size size) {
    List<Map> chatData = [
      {
        'message': 'Hi',
        'isMe': true,
      },
      {
        'message': 'sfsufh syfyusgf sgfs fgsd gf',
        'isMe': true,
      },
      {
        'message': 'How are you?',
        'isMe': false,
      },
      {
        'message': 'sfsufh syfyusgf sgfs',
        'isMe': true,
      },
      {
        'message': 'How are you?sdfsfs',
        'isMe': false,
      },
      {
        'message': 'How are you?sdfsfs',
        'isMe': false,
      },
      {
        'message': 'Hi ... iksjfgdhgdsgds ',
        'isMe': true,
      },
      {
        'message': 'sfsufh syfyusgf sgfs fgsd gf',
        'isMe': true,
      },
      {
        'message': 'How are you?',
        'isMe': false,
      },
      {
        'message': 'sfsufh syfyusgf sgfs',
        'isMe': true,
      },
      {
        'message': 'How are you?sdfsfs',
        'isMe': false,
      },
      {
        'message': 'How are you?sdfsfs',
        'isMe': false,
      },
    ];
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: chatData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
            child: Column(
              crossAxisAlignment: chatData[index]['isMe'] == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: size.width * .7,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.2),
                            borderRadius: chatData[index]['isMe'] == true
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10,
                          ),
                          child: Text(
                            chatData[index]['message'],
                            style: TextStyle(
                              color: Colors.black.withOpacity(.0),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 5,
                  width: size.width * .15,
                  color: Colors.black.withOpacity(.2),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

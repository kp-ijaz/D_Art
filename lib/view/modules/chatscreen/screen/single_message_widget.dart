import 'package:d_art/view/modules/chatscreen/models/messages_model.dart';
import 'package:flutter/material.dart';

class SingleMessageWidget extends StatelessWidget {
  final Color backgroundColor;
  final CrossAxisAlignment alignment;
  final bool? isMe;
  final Datum data;

  const SingleMessageWidget({
    super.key,
    required this.backgroundColor,
    required this.alignment,
    this.isMe,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10.0),
      child: Column(
        crossAxisAlignment: alignment,
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
                      color: backgroundColor,
                      borderRadius: isMe == null
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
                      data.message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            data.time!,
            style: TextStyle(color: Colors.black.withOpacity(.5)),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {required this.message,
      required this.isMe,
      super.key,
      required this.senderImage,
      required this.senderName});
  final String message;
  final String senderImage;
  final String senderName;

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment:
            !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(senderImage),
            ),
          Container(
            decoration: BoxDecoration(
              color: !isMe
                  ? Colors.grey[350]
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: !isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomRight: !isMe
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: MediaQuery.of(context).size.width / 1.5,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).textTheme.headlineSmall!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).textTheme.headlineSmall!.color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

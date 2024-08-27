import 'package:sperro_neu/constants/colors.dart';
import 'package:sperro_neu/constants/widgets.dart';
import 'package:sperro_neu/models/popup_menu_model.dart';
import 'package:sperro_neu/screens/chat/user_chat_screen.dart';
import 'package:sperro_neu/services/auth.dart';
import 'package:sperro_neu/services/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChatCard({Key? key, required this.data}) : super(key: key);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  UserService firebaseUser = UserService();
  DocumentSnapshot? document;
  Auth authService = Auth();
  String lastChatDate = '';

  @override
  void initState() {
    super.initState();
    getProductDetails();
    getChatTime();
  }

  void getProductDetails() {
    firebaseUser
        .getProductDetails(widget.data['product']['product_id'])
        .then((value) {
      if (mounted) {
        setState(() {
          document = value;
        });
      }
    }).catchError((error) {
      // Handle any errors here, such as logging or showing a message
    });
  }

  void getChatTime() {
    var date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.data['lastChatTime']));
    var today = DateFormat.yMMMd().format(DateTime.now());

    setState(() {
      lastChatDate = (date == today) ? 'Today' : date;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (document == null) {
      return Container(); // Return an empty container if the document is null
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: whiteColor,
      child: Stack(
        children: [
          ListTile(
            onTap: () {
              authService.messages.doc(widget.data['chatroomId']).update({
                'read': true, // Ensure it's a boolean value
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserChatScreen(
                    chatroomId: widget.data['chatroomId'],
                  ),
                ),
              );
            },
            leading: Image.network(
              document!['images'][0],
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image,
                    size: 60); // Handle image loading error
              },
            ),
            title: Text(
              document!['title'],
              style: TextStyle(
                fontWeight: widget.data['read'] == true
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document!['description'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.data['lastChat'] != null)
                  Text(
                    widget.data['lastChat'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: customPopUpMenu(
              context: context,
              chatroomId: widget.data['chatroomId'],
            ),
          ),
          Positioned(
            right: 20,
            child: Text(lastChatDate),
          ),
        ],
      ),
    );
  }
}

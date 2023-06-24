import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urban_sketchers/models/notification.dart';
import 'package:urban_sketchers/utils/app_colors.dart';
import 'package:urban_sketchers/widgets/individual_post_view.dart';
import 'package:urban_sketchers/widgets/widgets.dart';
import 'package:urban_sketchers/models/user.dart';
import 'package:provider/provider.dart';

/// NotificationPage is a stateful widget used to showing in-app notification to user about their posts.
class NotificationPage extends StatefulWidget {
  /// user uid
  final String userID;

  /// FirebaseFirestore instance
  final FirebaseFirestore _firestore;

  /// constructor
  const NotificationPage({
    Key? key,
    required this.userID,
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<MyNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = NotificationModel(firestore: widget._firestore)
        .getNotifications(widget.userID);
    NotificationModel(firestore: widget._firestore)
        .markNotificationAsRead(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: FutureBuilder<List<MyNotification>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print('Error while fetching notifications: ${snapshot.error}');
              return Center(child: Text("An error occurred"));
            }

            final notifications = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                height: 1,
              ),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return InkWell(
                  key: Key(notification.post.postID),
                  onTap: () {
                    showPost(context, widget.userID, notification.post,
                        widget._firestore);
                  },
                  child: Container(
                    color: notification.isNew
                        ? AppColors.primaryFocusColor
                        : AppColors.iconColor,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 16.0),
                      leading: GestureDetector(
                        child: circularProfilePic(
                            notification.user.profilePic, 25),
                      ),
                      title: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: '@${notification.user.username} ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            TextSpan(
                              text: notification.type == 'liked'
                                  ? 'liked your post'
                                  : 'commented on your post',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 80, // set the appropriate width here
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            notification.post.mediaUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

// ...
          },
        ),
      ),
    );
  }
}

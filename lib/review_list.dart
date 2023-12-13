import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var reviews = snapshot.data!.docs;
          List<Widget> reviewWidgets = [];

          for (var review in reviews) {
            var data = review.data() as Map<String, dynamic>;
            var reviewWidget = ListTile(
              title: Text('Username: ${data['username']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${data['location']}'),
                  Text('Rating: ${data['rating']}'),
                  Text('Comment: ${data['comment']}'),
                  Text('Date: ${DateTime.parse(data['date'].toString())}'),
                ],
              ),
            );
            reviewWidgets.add(reviewWidget);
          }

          return ListView(
            children: reviewWidgets,
          );
        },
      ),
    );
  }
}

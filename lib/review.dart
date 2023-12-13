import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Review {
  String id;
  String username;
  String location;
  String rating;
  String comment;
  DateTime date;

  Review({
    required this.id,
    required this.username,
    required this.location,
    required this.rating,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'location': location,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Review App',
      home: ReviewScreen(),
    );
  }
}

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _selectedRating = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username',filled: true,
                  fillColor: Colors.grey[200],),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location',
                  filled: true,
                  fillColor: Colors.grey[200],),
              ),
              SizedBox(height: 16),
              Text('Rating:',
                style: TextStyle(
                  color: Colors.black, // Change the text color
                  fontSize: 16.0,),
              ),
              Column(
                children: [
                  buildRadioButton('Excellent'),
                  buildRadioButton('Good'),
                  buildRadioButton('Fair'),
                  buildRadioButton('Poor'),
                  buildRadioButton('Very Poor'),
                ],
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(labelText: 'Comment',
                  filled: true,
                  fillColor: Colors.grey[200],),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                style: ElevatedButton.styleFrom(
              primary: Colors.deepOrange, // Change the button background color
              ),
                child: Text('Insert Image'),
              ),

              // Display the picked image
              _image != null ? Image.file(_image!) : Container(),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  submitReview();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                ),
                child: Text('Submit Reviews'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/review_list');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                ),
                child: Text('View Reviews'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRadioButton(String text) {
    return Row(
      children: [
        Radio(
          value: text,
          groupValue: _selectedRating,
          onChanged: (value) {
            setState(() {
              _selectedRating = value as String;
            });
          },
        ),
        Text(text),
      ],
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }


  Future<void> submitReview() async {
    if (_selectedRating.isEmpty) {
      // Rating not selected
      return;
    }

    // Create a Review object with the entered data
    Review newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: _usernameController.text,
      location: _locationController.text,
      rating: _selectedRating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    // Save the image to Firebase Storage
    if (_image != null) {
      // Implement code to upload the image to Firebase Storage and get the download URL
      // For simplicity, you can print the image path here
      print('Image Path: ${_image!.path}');
    }

    // Save the review to Firestore
    await FirebaseFirestore.instance.collection('reviews').doc(newReview.id).set(newReview.toMap());

    // Print the review details (for testing purposes)
    print('New Review: $newReview');
  }
}

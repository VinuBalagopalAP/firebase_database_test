import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget {
  final String userKey;

  const UpdateUser({
    Key? key,
    required this.userKey,
  }) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref().child('users');
    getUserData();
  }

  void getUserData() async {
    DataSnapshot snapshot =
        (await ref.child(widget.userKey).once()) as DataSnapshot;

    Map user = snapshot.value as Map;

    nameController.text = user['name'];
    ageController.text = user['age'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter some text',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: ageController,
              decoration: const InputDecoration(
                hintText: 'Enter age',
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Map<String, String> user = {
                'name': nameController.text,
                'age': ageController.text,
              };

              ref.child(widget.userKey).update(user).then((value) {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Update user data'),
          ),
        ],
      ),
    );
  }
}

import 'package:database_test/screens/update_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FetchedData extends StatefulWidget {
  const FetchedData({Key? key}) : super(key: key);

  @override
  State<FetchedData> createState() => _FetchedDataState();
}

class _FetchedDataState extends State<FetchedData> {
  Query ref = FirebaseDatabase.instance.ref().child('users');

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      query: ref,
      itemBuilder: ((context, snapshot, animation, index) {
        Map user = snapshot.value as Map;
        user['key'] = snapshot.key;

        return NameAge(user: user);
      }),
    );
  }
}

class NameAge extends StatelessWidget {
  final Map user;

  const NameAge({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.yellowAccent,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Column(
        children: [
          Text(
            user['name'],
            style: const TextStyle(fontSize: 24.0),
          ),
          Text(
            user['age'],
            style: const TextStyle(fontSize: 24.0),
          ),
          Row(
            children: [
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  FirebaseDatabase.instance
                      .ref()
                      .child('users')
                      .child(user['key'])
                      .remove();
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateUser(
                        userKey: user['key'],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

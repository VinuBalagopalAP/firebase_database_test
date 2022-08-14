import 'package:database_test/screens/fetched_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({
    super.key,
  });

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref().child('users');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

            ref.push().set(user);
          },
          child: const Text('Create new user'),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FetchedData(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue,
            ),
            child: const Text(
              'Go to FetchData',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class Login extends StatelessWidget with InputValidationMixin {
  Login({Key? key}) : super(key: key);

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                validator: (email) {
                  if (isEmailValid(email!)) {
                    return null;
                  } else {
                    return 'Enter a valid email address';
                  }
                },
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                maxLength: 10,
                obscureText: true,
                validator: (password) {
                  if (isPasswordValid(password!)) {
                    return null;
                  } else {
                    return 'Enter a valid password';
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () {
                    if (formGlobalKey.currentState!.validate()) {
                      formGlobalKey.currentState!.save();
                      // use the email provided here
                    }
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  /// [ isEmailValid ] checks if the email is valid.
  bool isEmailValid(String email) {
    bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      multiLine: false,
      caseSensitive: false,
    ).hasMatch(email);

    return emailValid;
  }

  /// [ ispasswordValid ] checks if the password is valid.
  bool isPasswordValid(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);

    return password.length == 6 && regExp.hasMatch(password);
  }
}

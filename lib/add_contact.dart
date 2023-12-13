import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_book/contact.dart';

import 'main.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  AddContactState createState() => AddContactState();
}

class AddContactState extends State<AddContact> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController photoURLController = TextEditingController();

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoTheme(
            data: const CupertinoThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.blue, // Set your primary color
              scaffoldBackgroundColor: Colors.white, // Set your background color
            ),
            child: CupertinoAlertDialog(
              title: const Text('Contact Added'),
              content: const Text('The contact has been added successfully!'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    GoRouter.of(context).go('/contact_list');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          return AlertDialog(
            title: const Text('Contact Added'),
            content: const Text('The contact has been added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  GoRouter.of(context).go('/contact_list');
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      },
    );
  }
  void sortContacts() {
    // Sort contacts by fullName
    contacts.sort((a, b) => a.fullName.compareTo(b.fullName));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Contact'),
        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: photoURLController,
              decoration: const InputDecoration(labelText: 'Photo URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneNumberController.text.isNotEmpty &&
                    phoneNumberController.text.length == 11 &&
                    emailController.text.isNotEmpty &&
                    photoURLController.text.isNotEmpty) {
                  Contact newContact = Contact(
                    fullName: nameController.text,
                    phoneNumber: phoneNumberController.text,
                    email: emailController.text,
                    photoURL: photoURLController.text,
                  );

                  contacts.add(newContact);
                  sortContacts();
                  showSuccessDialog(context);

                } else if (phoneNumberController.text.length != 11) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid phone number'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all the fields'),
                    ),
                  );
                }
              },
              child: const Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_book/contact.dart';

class PhoneBook extends StatelessWidget {
  final List<Contact> contacts;

  const PhoneBook({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    _deleteContact(context, contact);
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: buildContactListTileWithCards(context, contact),
          );
        },
      ),
    );
  }

  Widget buildContactListTileWithCards(BuildContext context, Contact contact) => Card(
    child: ListTile(
      leading: contact.photoURL != null
          ? ClipOval(
        child: Image.network(
          contact.photoURL!,
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
      )
          : const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.person),
      ),
      title: Text(contact.fullName),
      subtitle: Text(contact.phoneNumber),
      onTap: () {
        GoRouter.of(context).go('/contact_details/${contact.phoneNumber}');
      },
    ),
  );

  void _deleteContact(BuildContext context, Contact contact) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.fullName}?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              contacts.remove(contact);
              Navigator.of(context).pop();
              GoRouter.of(context).go('/contact_list');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${contact.fullName} deleted'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            isDestructiveAction: true,
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              GoRouter.of(context).go('/contact_list');
            },
            isDefaultAction: true,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_book/contact.dart';
import 'package:phone_book/contact_details.dart';
import 'package:phone_book/page_home.dart';
import 'package:phone_book/phone_book.dart';
import 'package:phone_book/add_contact.dart';

void main() {
  runApp(const MyApp());
}

final faker = Faker();

List<Contact> contacts = List<Contact>.generate(
  20,
  (index) => Contact(
    fullName: faker.person.name(),
    phoneNumber: generateRandomPhoneNumber(),
    email: faker.internet.email(),
    photoURL: 'https://picsum.photos/200/300?random=$index',
  ),
);

String generateRandomPhoneNumber() {
  final random = Random();
  int remainingDigits = 10000000 + random.nextInt(90000000);
  int lastDigit = remainingDigits % 10;
  String phoneNumber =
      '053${remainingDigits.toString().substring(1, 4)}${remainingDigits.toString().substring(4)}$lastDigit';
  return phoneNumber;
}

void sortContacts() {
  // Sort contacts by fullName
  contacts.sort((a, b) => a.fullName.compareTo(b.fullName));
}

final GoRouter _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      sortContacts();
      return const PageHome();
    },
  ),
  GoRoute(
    path: '/contact_list',
    builder: (context, state) {
      sortContacts();
      return PhoneBook(contacts: contacts);
    },
  ),
  GoRoute(
    path: '/add_contact',
    builder: (context, state) => const AddContact(),
  ),
  GoRoute(
    path: '/contact_details/:phoneNumber',
    builder: (context, state) {

      String phoneNumber = state.pathParameters['phoneNumber']!;

      Contact contact = contacts.firstWhere((contact) => contact.phoneNumber == phoneNumber);

      return ContactDetailsPage(contact: contact);
    },
  )
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Phone Book App',
      routerConfig: _router,
      theme: ThemeData.dark(),
    );
  }
}

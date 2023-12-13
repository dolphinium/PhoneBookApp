import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageHome extends StatelessWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phonebook')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/add_contact'),
              child: const Text('Add Contact'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/contact_list'),
              child: const Text('Show Contact List'),
            ),
          ],
        ),
      ),
    );
  }
}

  import 'package:flutter/material.dart';
  import 'package:easy_localization/easy_localization.dart';

  class UserInfoPage extends StatelessWidget {
    final String name;
    final String dob;
    final String phone;
    final String email;
    final String country;

    const UserInfoPage({
      super.key,
      required this.name,
      required this.dob,
      required this.phone,
      required this.email,
      required this.country,
    });

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Information'),
          backgroundColor: const Color.fromARGB(255, 127, 104, 190),
          actions: [
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              onSelected: (Locale locale) {
                context.setLocale(locale);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: Locale('en'), child: Text('English')),
                const PopupMenuItem(value: Locale('kk'), child: Text('Қазақша')),
                const PopupMenuItem(value: Locale('ru'), child: Text('Русский')),
              ],
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F5AF0), Color(0xFFEC4899), Color.fromARGB(255, 184, 110, 156)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            // ignore: deprecated_member_use
            color: const Color.fromARGB(255, 239, 174, 226).withOpacity(0.9),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Registered Details:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildInfoRow('Full Name:', name),
                  _buildInfoRow('Date of Birth:', dob),
                  _buildInfoRow('Phone Number:', phone),
                  _buildInfoRow('Email:', email),
                  _buildInfoRow('Country:', country),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildInfoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(value)),
          ],
        ),
      );
    }
  }

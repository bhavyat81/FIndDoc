import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar section
            Container(
              width: double.infinity,
              color: Colors.teal.shade700,
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: Text('👤',
                        style: TextStyle(fontSize: 44)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Guest User',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '+91 XXXXXXXXXX',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // City
            _settingsTile(
              icon: Icons.location_city,
              title: 'Selected City',
              trailing: Chip(
                label: const Text('Vadodara'),
                backgroundColor: Colors.teal.shade50,
                labelStyle: TextStyle(color: Colors.teal.shade800),
              ),
            ),

            // Language
            _settingsTile(
              icon: Icons.language,
              title: 'Language',
              trailing: DropdownButton<String>(
                value: _language,
                items: ['English', 'Gujarati'].map((l) {
                  return DropdownMenuItem(value: l, child: Text(l));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _language = val);
                },
                underline: const SizedBox(),
              ),
            ),

            // Dark mode
            _settingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
                activeColor: Colors.teal,
              ),
            ),

            const Divider(),

            // About
            _settingsTile(
              icon: Icons.info_outline,
              title: 'About FindDoc',
              subtitle:
                  'FindDoc helps you find the right doctor near you in Vadodara.',
            ),
            _settingsTile(
              icon: Icons.verified,
              title: 'Version',
              subtitle: '1.0.0',
            ),
            _settingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
            ),
            _settingsTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing,
    );
  }
}

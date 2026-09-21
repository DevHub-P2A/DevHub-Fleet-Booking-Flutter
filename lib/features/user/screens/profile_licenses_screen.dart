import 'package:flutter/material.dart';

class ProfileLicensesScreen extends StatelessWidget {
  const ProfileLicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Profile & Licenses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xff101828),
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Manage your personal information and licenses.',
              style: TextStyle(fontSize: 12, color: Color(0xff667085)),
            ),
          ],
        ),
      ),
    );
  }
}

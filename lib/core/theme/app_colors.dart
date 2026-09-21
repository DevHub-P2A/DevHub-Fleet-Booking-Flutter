import 'package:flutter/material.dart';

/// Every colour in the app lives here.
///
/// These values were extracted from the existing screens so nothing changes
/// visually — but from now on use `AppColors.primary` instead of
/// `const Color(0xff155eef)` so a rebrand is a one-file edit.
class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xff155eef);
  static const Color primaryDark = Color(0xff1043b5);
  static const Color primarySoft = Color(0xffeef2ff);

  // Surfaces
  static const Color background = Color(0xfff7f8fa);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xfff9fafb);

  // Borders / dividers
  static const Color border = Color(0xffd9deeb);
  static const Color borderStrong = Color(0xffd0d5dd);
  static const Color divider = Color(0xffeaecf0);

  // Text
  static const Color textPrimary = Color(0xff182230);
  static const Color textSecondary = Color(0xff526078);
  static const Color textTertiary = Color(0xff667085);
  static const Color textBody = Color(0xff344054);

  // Status — success
  static const Color success = Color(0xff067647);
  static const Color successSoft = Color(0xffecfdf3);
  static const Color successBorder = Color(0xffabefc6);

  // Status — warning / pending
  static const Color warning = Color(0xffb54708);
  static const Color warningSoft = Color(0xfffffaeb);
  static const Color warningBorder = Color(0xfffedf89);

  // Status — danger
  static const Color danger = Color(0xffb42318);
  static const Color dangerSoft = Color(0xfffef3f2);
  static const Color dangerBorder = Color(0xfffecdca);

  // Status — neutral / info
  static const Color neutral = Color(0xff475467);
  static const Color neutralSoft = Color(0xfff2f4f7);
  static const Color neutralBorder = Color(0xffe4e7ec);

  static const Color infoSoft = Color(0xffeff4ff);
  static const Color purple = Color(0xff7a5af8);
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_pill.dart';
import '../models/admin_profile_model.dart';
import '../providers/admin_profile_provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProfileProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminProfileProvider>();
    final bool mobile = MediaQuery.of(context).size.width < 700;

    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? 16 : 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: _buildBody(provider, mobile),
      ),
    );
  }

  Widget _buildBody(AdminProfileProvider provider, bool mobile) {
    if (provider.isLoading && provider.profile == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.hasError && provider.profile == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 14),
            Text(provider.errorMessage ?? 'Something went wrong.', style: AppTextStyles.body),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: provider.load, child: const Text('Try again')),
          ],
        ),
      );
    }

    final profile = provider.profile!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Admin Profile', style: AppTextStyles.pageTitle),
        const SizedBox(height: 20),
        _buildHeaderCard(profile, mobile),
        const SizedBox(height: 18),
        _buildPersonalInfoCard(profile, mobile),
        const SizedBox(height: 18),
        _buildAccountInfoCard(profile, mobile),
      ],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeaderCard(AdminProfileModel profile, bool mobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 14,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      profile.initials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.fullName,
                        style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      StatusPill.success(profile.accountStatus),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${profile.role} • ${profile.email}', style: AppTextStyles.body),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 12, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(profile.location, style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (!mobile) const Spacer(),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showComingSoon(context, 'Change password'),
                icon: const Icon(Icons.vpn_key_outlined, size: 16),
                label: const Text('Change Password'),
              ),
              ElevatedButton.icon(
                onPressed: () => _showComingSoon(context, 'Edit profile'),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PERSONAL INFO
  // ============================================================

  Widget _buildPersonalInfoCard(AdminProfileModel profile, bool mobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          const Text(
            'Read-only synchronized campus operations directory',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 18),
          _buildFieldGrid(mobile, [
            _field('Full Name', profile.fullName),
            _field('Email Address', profile.email),
            _field('Phone Number', profile.phoneNumber),
          ]),
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT INFO
  // ============================================================

  Widget _buildAccountInfoCard(AdminProfileModel profile, bool mobile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Account Information', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          const Text('System authority and access tier credentials', style: AppTextStyles.caption),
          const SizedBox(height: 18),

          _buildInfoTile(
            mobile,
            icon: Icons.shield_outlined,
            label: 'Role',
            value: profile.role,
            note: profile.operationalNote,
          ),
          const SizedBox(height: 14),
          _buildInfoTile(
            mobile,
            icon: Icons.verified_user_outlined,
            label: 'Account Status',
            value: profile.accountStatus,
            note: 'Operational • Verified SSO link active',
            trailing: StatusPill.success('Operational'),
          ),
          const SizedBox(height: 14),
          _buildInfoTile(
            mobile,
            icon: Icons.schedule,
            label: 'Last Login',
            value: 'Today at ${_formatTime(profile.lastLoginAt)}',
            note: 'Logged in from ${profile.lastLoginLocation}',
          ),
          const SizedBox(height: 14),
          _buildInfoTile(
            mobile,
            icon: Icons.lock_outline,
            label: 'Security Clearance',
            value: profile.securityClearance,
            note: profile.securityNote,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    bool mobile, {
    required IconData icon,
    required String label,
    required String value,
    required String note,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: AppTextStyles.bodyStrong.copyWith(fontSize: 14),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing,
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(note, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldGrid(bool mobile, List<Widget> fields) {
    if (mobile) {
      return Column(
        children: [
          for (final f in fields) ...[f, const SizedBox(height: 16)],
        ],
      );
    }
    return Wrap(
      spacing: 20,
      runSpacing: 18,
      children: [
        for (final f in fields) SizedBox(width: 260, child: f),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(value, style: AppTextStyles.bodyStrong),
        ),
      ],
    );
  }

  String _formatTime(DateTime date) {
    final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — coming next')),
    );
  }
}

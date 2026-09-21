import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/dispatcher_profile_model.dart';
import '../providers/dispatcher_profile_provider.dart';

class DispatcherProfileScreen extends StatefulWidget {
  const DispatcherProfileScreen({super.key});

  @override
  State<DispatcherProfileScreen> createState() =>
      _DispatcherProfileScreenState();
}

class _DispatcherProfileScreenState extends State<DispatcherProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DispatcherProfileProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DispatcherProfileProvider>();
    final bool mobile = MediaQuery.of(context).size.width < 700;

    return SingleChildScrollView(
      padding: EdgeInsets.all(mobile ? 16 : 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: _buildBody(provider, mobile),
      ),
    );
  }

  Widget _buildBody(DispatcherProfileProvider provider, bool mobile) {
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
            const Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 14),
            Text(
              provider.errorMessage ?? 'Something went wrong.',
              style: AppTextStyles.body,
            ),
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
        const Text('Dispatcher Profile', style: AppTextStyles.pageTitle),
        const SizedBox(height: 20),
        _buildHeaderCard(profile, mobile),
        const SizedBox(height: 18),
        _buildInfoCard(profile, mobile),
      ],
    );
  }

  Widget _buildHeaderCard(DispatcherProfileModel profile, bool mobile) {
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
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  profile.initials,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(profile.fullName, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
            ],
          ),
          if (!mobile) const Spacer(),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showComingSoon(context, 'Change password'),
                icon: const Icon(Icons.lock_reset, size: 16),
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

  Widget _buildInfoCard(DispatcherProfileModel profile, bool mobile) {
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
          const SizedBox(height: 20),

          _buildFieldGrid(mobile, [
            _field('Full Name', profile.fullName),
            _field('Email Address', profile.email),
            _field('Phone Number', profile.phoneNumber),
            _field('Employee ID', profile.employeeId),
            _field('Department', profile.department),
            _field('Shift', profile.shift),
          ]),
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
        for (final f in fields) SizedBox(width: 330, child: f),
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — coming next')),
    );
  }
}

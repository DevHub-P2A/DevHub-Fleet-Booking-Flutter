import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/admin/data/admin_repository.dart';
import 'features/admin/providers/admin_profile_provider.dart';
import 'features/admin/providers/vehicle_assignment_provider.dart';
import 'features/dispatcher/data/dispatcher_repository.dart';
import 'features/dispatcher/providers/dispatcher_dashboard_provider.dart';
import 'features/dispatcher/providers/dispatcher_profile_provider.dart';
import 'features/driver/data/driver_repository.dart';
import 'features/driver/providers/driver_dashboard_provider.dart';
import 'features/user/screens/login_screen.dart';

void main() {
  runApp(const FleetBookingApp());
}

class FleetBookingApp extends StatelessWidget {
  const FleetBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ── Repositories ──────────────────────────────────────────────
        // This is the only place any mock is named. When an API is ready:
        //   Provider<DispatcherRepository>(
        //     create: (_) => ApiDispatcherRepository(client),
        //   ),
        // No provider, screen, or model changes anywhere else.
        Provider<DispatcherRepository>(
          create: (_) => MockDispatcherRepository(),
        ),
        Provider<DriverRepository>(create: (_) => MockDriverRepository()),
        Provider<AdminRepository>(create: (_) => MockAdminRepository()),

        // ── Feature providers ─────────────────────────────────────────
        ChangeNotifierProvider<DispatcherDashboardProvider>(
          create: (context) => DispatcherDashboardProvider(
            repository: context.read<DispatcherRepository>(),
          ),
        ),
        ChangeNotifierProvider<DispatcherProfileProvider>(
          create: (context) => DispatcherProfileProvider(
            repository: context.read<DispatcherRepository>(),
          ),
        ),
        ChangeNotifierProvider<DriverDashboardProvider>(
          create: (context) => DriverDashboardProvider(
            repository: context.read<DriverRepository>(),
          ),
        ),
        ChangeNotifierProvider<AdminProfileProvider>(
          create: (context) => AdminProfileProvider(
            repository: context.read<AdminRepository>(),
          ),
        ),
        ChangeNotifierProvider<VehicleAssignmentProvider>(
          create: (context) => VehicleAssignmentProvider(
            repository: context.read<AdminRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fleet Booking',
        theme: AppTheme.light,
        home: const LoginScreen(),
      ),
    );
  }
}

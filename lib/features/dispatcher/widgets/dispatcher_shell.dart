import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../screens/dispatcher_dashboard_screen.dart';
import '../screens/dispatcher_profile_screen.dart';

/// Sidebar-on-desktop / drawer-on-mobile shell for the dispatcher role.
///
/// Mirrors `UserShell` and `DriverShell` so all three roles behave the same.
/// The placeholder entries are the screens still to be built — they render a
/// "coming soon" panel rather than being hidden, so the navigation model is
/// visible from day one.
class DispatcherShell extends StatefulWidget {
  const DispatcherShell({super.key});

  @override
  State<DispatcherShell> createState() => _DispatcherShellState();
}

class _DispatcherShellState extends State<DispatcherShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  final List<String> menuTitles = const [
    'Dashboard',
    'Reservation Requests',
    'Vehicle Assignment',
    'Trip Management',
    'Trip Tracking',
    'Profile',
  ];

  final List<IconData> menuIcons = const [
    Icons.grid_view_outlined,
    Icons.inbox_outlined,
    Icons.directions_car_outlined,
    Icons.alt_route_outlined,
    Icons.my_location_outlined,
    Icons.person_outline,
  ];

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (_isMobile(context)) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  Widget _buildCurrentScreen() {
    switch (selectedIndex) {
      case 0:
        return const DispatcherDashboardScreen();
      case 5:
        return const DispatcherProfileScreen();
      default:
        return _buildComingSoon(menuTitles[selectedIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = _isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: mobile ? _buildDrawer() : null,
      appBar: mobile ? _buildMobileAppBar() : null,
      body: mobile ? _buildCurrentScreen() : _buildDesktopLayout(),
    );
  }

  // ============================================================
  // MOBILE APP BAR
  // ============================================================

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 0,

      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 25),
      ),

      title: const Text(
        'FleetFlow',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),

      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.headset_mic_outlined,
                size: 16,
                color: AppColors.textTertiary,
              ),
              SizedBox(width: 5),
              Text(
                'Dispatcher',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP LAYOUT
  // ============================================================

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildDesktopSidebar(),
        Expanded(child: _buildCurrentScreen()),
      ],
    );
  }

  Widget _buildDesktopSidebar() {
    return Container(
      width: 220,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.neutralBorder)),
      ),
      child: Column(
        children: [
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'FleetFlow',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: menuTitles.length,
              itemBuilder: (context, index) => _buildMenuItem(index),
            ),
          ),

          _buildUserFooter(),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER - MOBILE
  // ============================================================

  Widget _buildDrawer() {
    return Drawer(
      width: 270,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.neutralBorder),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'FleetFlow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: menuTitles.length,
                itemBuilder: (context, index) => _buildMenuItem(index),
              ),
            ),

            _buildUserFooter(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem(int index) {
    final bool selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected ? AppColors.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _selectPage(index),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  menuIcons[index],
                  size: 19,
                  color: selected ? AppColors.primary : AppColors.textTertiary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    menuTitles[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // USER FOOTER
  // ============================================================

  Widget _buildUserFooter() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primarySoft,
            child: Icon(
              Icons.headset_mic_outlined,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          SizedBox(width: 9),

          Expanded(
            child: Text(
              'Dispatcher',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textBody,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLACEHOLDER
  // ============================================================

  Widget _buildComingSoon(String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.construction_outlined,
              size: 38,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'This screen is next on the build list.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}

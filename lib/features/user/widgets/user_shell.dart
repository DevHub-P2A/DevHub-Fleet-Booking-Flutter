import 'package:flutter/material.dart';

import '../screens/vehicle_catalog_screen.dart';
import '../screens/reservations_screen.dart';
import '../screens/active_trip_screen.dart';
import '../screens/profile_licenses_screen.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  final List<Widget> screens = const [
    VehicleCatalogScreen(),
    ReservationsScreen(),
    ActiveTripScreen(),
    ProfileLicensesScreen(),
  ];

  final List<IconData> menuIcons = const [
    Icons.directions_car_outlined,
    Icons.calendar_today_outlined,
    Icons.alt_route_outlined,
    Icons.person_outline,
  ];

  final List<String> menuTitles = const [
    'Vehicle Catalog',
    'My Reservations',
    'Active Trip',
    'Profile & Licenses',
  ];

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Close Drawer only on mobile.
    if (_isMobile(context)) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = _isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xfff7f8fa),

      // Drawer ONLY on mobile.
      drawer: mobile ? _buildDrawer() : null,

      appBar: mobile ? _buildMobileAppBar() : null,

      body: mobile ? _buildMobileBody() : _buildDesktopLayout(),
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

      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.menu, color: Color(0xff182230), size: 25),
      ),

      titleSpacing: 0,

      title: const Text(
        'FleetFlow',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff182230),
        ),
      ),

      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xffd0d5dd)),
          ),
          child: const Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Color(0xff667085)),
              SizedBox(width: 5),
              Text(
                'User',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff344054),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE BODY
  // ============================================================

  Widget _buildMobileBody() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 30),
        child: screens[selectedIndex],
      ),
    );
  }

  // ============================================================
  // DESKTOP LAYOUT
  // ============================================================

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildDesktopSidebar(),

        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
              child: screens[selectedIndex],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP SIDEBAR
  // ============================================================

  Widget _buildDesktopSidebar() {
    return Container(
      width: 220,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xffe4e7ec))),
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
                color: Color(0xff182230),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: menuTitles.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
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
            // Drawer Header
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffe4e7ec))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xffeef4ff),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      size: 20,
                      color: Color(0xff2864e8),
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'FleetFlow',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff182230),
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
                      color: Color(0xff667085),
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
                itemBuilder: (context, index) {
                  return _buildMenuItem(index);
                },
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
        color: selected ? const Color(0xffeef4ff) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),

          onTap: () {
            _selectPage(index);
          },

          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  menuIcons[index],
                  size: 19,
                  color: selected
                      ? const Color(0xff2864e8)
                      : const Color(0xff667085),
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
                          ? const Color(0xff2864e8)
                          : const Color(0xff667085),
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
        color: const Color(0xfff8f9fc),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xffe0ebff),
            child: Icon(
              Icons.person_outline,
              size: 18,
              color: Color(0xff2864e8),
            ),
          ),

          SizedBox(width: 9),

          Expanded(
            child: Text(
              'User',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xff344054),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

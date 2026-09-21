import 'package:flutter/material.dart';

import 'my_trip_screen.dart';
import 'driver_profile_screen.dart';
import 'driver_dashboard_screen.dart';

class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 1;

  final List<String> menuTitles = const ['Dashboard', 'My Trip', 'Profile'];

  final List<IconData> menuIcons = const [
    Icons.grid_view_outlined,
    Icons.directions_car_outlined,
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
        return const DriverDashboardScreen();

      case 1:
        return const MyTripScreen();

      case 2:
        return const DriverProfileScreen();

      default:
        return const MyTripScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = _isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xfff7f8fc),
      drawer: mobile ? _buildDrawer() : null,
      appBar: mobile ? _buildMobileAppBar() : null,
      body: mobile ? _buildMobileBody() : _buildDesktopLayout(),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.menu, color: Color(0xff182230)),
      ),
      titleSpacing: 0,
      title: const Text(
        'FleetFlow',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Color(0xff155eef),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xffeef4ff),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(
            Icons.notifications_none_outlined,
            size: 18,
            color: Color(0xff344054),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileBody() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        child: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        _buildDesktopSidebar(),
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
              child: Column(
                children: [
                  _buildDesktopTopBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: _buildCurrentScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTopBar() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffe4e7ec))),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Good morning, Ahmed',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xff182230),
              ),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xfff2f4f7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 17,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xffd0d5dd),
            child: Icon(Icons.person, size: 17, color: Color(0xff667085)),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Container(
      width: 145,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xffe4e7ec))),
      ),
      child: Column(
        children: [
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe4e7ec))),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xff2864e8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'FleetFlow',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff155eef),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              itemCount: menuTitles.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: 260,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffe4e7ec))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xff2864e8),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'FleetFlow',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff155eef),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.closeDrawer();
                    },
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                itemCount: menuTitles.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    final bool selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected ? const Color(0xffeef4ff) : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () {
            _selectPage(index);
          },
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              children: [
                Icon(
                  menuIcons[index],
                  size: 15,
                  color: selected
                      ? const Color(0xff155eef)
                      : const Color(0xff667085),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    menuTitles[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? const Color(0xff155eef)
                          : const Color(0xff667085),
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xff155eef),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


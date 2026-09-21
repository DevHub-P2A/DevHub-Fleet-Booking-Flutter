import 'package:flutter/material.dart';

class ActiveTripScreen extends StatelessWidget {
  const ActiveTripScreen({super.key});

  static const String vehicleName = 'Toyota Hiace Commuter';
  static const String vehicleType = '2024 Passenger Van';
  static const String plateNumber = 'UCF-8820';
  static const String seats = '12 Seats';
  static const String powertrain = 'Hybrid';
  static const String transmission = 'Automatic';

  static const String currentLocation =
      'Approaching Mountain Spur Junction (Hwy 12 Corridor)';

  static const String destination = 'Pine Ridge Field Station';
  static const String pickupLocation = 'Central Campus - Gate 2';

  static const String pickupDate = 'Oct 24, 2025 • 08:30 AM';
  static const String returnDate = 'Oct 24, 2025 • 05:00 PM';

  static const String speed = '54 km/h';
  static const String odometer = '34,566 km';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 20),

              if (mobile) _buildMobileLayout() else _buildDesktopLayout(),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Trip',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xff101828),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Track your current trip and vehicle.',
          style: TextStyle(fontSize: 12, color: Color(0xff667085)),
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _buildVehicleCard()),

          const SizedBox(width: 18),

          Expanded(flex: 6, child: _buildTripDetails()),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildVehicleCard(),

        const SizedBox(height: 14),

        _buildTripDetails(),
      ],
    );
  }

  // ============================================================
  // VEHICLE CARD
  // ============================================================

  Widget _buildVehicleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVehicleImage(),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vehicleName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff182230),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xffeef4ff),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Assigned Vehicle',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2864e8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          const Text(
            vehicleType,
            style: TextStyle(fontSize: 9, color: Color(0xff667085)),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(child: _buildVehicleStat('Capacity', seats)),
              Expanded(child: _buildVehicleStat('Fuel Level', '88% Full')),
              Expanded(child: _buildVehicleStat('Odometer', odometer)),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xfff8fafc),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xffe4e7ec)),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xffecfdf3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 13,
                    color: Color(0xff12b76a),
                  ),
                ),

                const SizedBox(width: 7),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fleet IoT Telematics Online',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff344054),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Speed limit compliance verified',
                        style: TextStyle(fontSize: 7, color: Color(0xff667085)),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffd1fadf),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Good',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff027a48),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VEHICLE IMAGE
  // ============================================================

  Widget _buildVehicleImage() {
    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xfff2f4f7),
        borderRadius: BorderRadius.circular(7),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/'
              'photo-1544620347-c4fd4a3d5957'
              '?auto=format&fit=crop&w=900&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.directions_car_outlined,
                    size: 55,
                    color: Color(0xff98a2b3),
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Plate: $plateNumber',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff344054),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VEHICLE STAT
  // ============================================================

  Widget _buildVehicleStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xfff8fafc),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 7, color: Color(0xff98a2b3)),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Color(0xff344054),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRIP DETAILS
  // ============================================================

  Widget _buildTripDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TRIP ITINERARY & ROUTE NAVIGATION',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: Color(0xff667085),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xffeef4ff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Departure: In 2 hours',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2864e8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildRoutePoint(
            title: pickupLocation,
            time: pickupDate,
            icon: Icons.radio_button_checked,
            iconColor: const Color(0xff2864e8),
            isCurrent: false,
          ),

          _buildCurrentLocation(),

          _buildRoutePoint(
            title: destination,
            time: returnDate,
            icon: Icons.location_on,
            iconColor: const Color(0xff98a2b3),
            isCurrent: false,
          ),

          const SizedBox(height: 14),

          _buildDateCards(),

          const SizedBox(height: 14),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined, size: 14),
                  label: const Text('View Trip Details'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 38),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff2864e8),
                    side: const BorderSide(color: Color(0xff2864e8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent_outlined, size: 14),
                  label: const Text('Contact Support'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 38),
                    foregroundColor: const Color(0xff344054),
                    side: const BorderSide(color: Color(0xffd0d5dd)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ROUTE POINT
  // ============================================================

  Widget _buildRoutePoint({
    required String title,
    required String time,
    required IconData icon,
    required Color iconColor,
    required bool isCurrent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 22, child: Icon(icon, size: 14, color: iconColor)),

        const SizedBox(width: 7),

        Expanded(
          child: Container(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff344054),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfff8fafc),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xff667085),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Widget _buildCurrentLocation() {
    return Container(
      margin: const EdgeInsets.only(left: 22, bottom: 10),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xfff0f7ff),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffdbeafe)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.my_location, size: 13, color: Color(0xff2864e8)),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'CURRENT LOCATION',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff2864e8),
                        ),
                      ),
                    ),

                    Text(
                      '$speed cruising',
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff027a48),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  currentLocation,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff344054),
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Estimated 26 minutes to destination • Traffic Normal',
                  style: TextStyle(fontSize: 7, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE CARDS
  // ============================================================

  Widget _buildDateCards() {
    return Row(
      children: [
        Expanded(
          child: _buildDateCard(
            title: 'PICKUP DATE AND TIME',
            value: pickupDate,
            icon: Icons.schedule_outlined,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _buildDateCard(
            title: 'RETURN DATE AND TIME',
            value: returnDate,
            icon: Icons.schedule_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xfff8fafc),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffeef0f3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w600,
              color: Color(0xff98a2b3),
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              Icon(icon, size: 11, color: const Color(0xff667085)),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff344054),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

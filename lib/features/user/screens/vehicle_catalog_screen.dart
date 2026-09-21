import 'package:flutter/material.dart';

import '../widgets/summary_card.dart';
import '../widgets/vehicle_card.dart';

class VehicleCatalogScreen extends StatefulWidget {
  const VehicleCatalogScreen({super.key});

  @override
  State<VehicleCatalogScreen> createState() => _VehicleCatalogScreenState();
}

class _VehicleCatalogScreenState extends State<VehicleCatalogScreen> {
  String vehicleType = 'All Types';
  String brand = 'All Brands';
  String seats = 'Any Capacity';
  String powertrain = 'All Powertrains';
  String transmission = 'Automatic Only';
  String accessibility = 'Standard / Any';

  final List<Map<String, String>> vehicles = [
    {
      'type': 'SEDAN',
      'name': 'Toyota Camry',
      'seats': '5 Seats',
      'transmission': 'Automatic',
      'location': 'Main Campus',
      'image': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb',
    },
    {
      'type': 'SUV',
      'name': 'Hyundai Tucson',
      'seats': '5 Seats',
      'transmission': 'Automatic',
      'location': 'North Campus',
      'image': 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6',
    },
    {
      'type': 'VAN',
      'name': 'Mercedes Sprinter',
      'seats': '12 Seats',
      'transmission': 'Automatic',
      'location': 'Transport Center',
      'image': 'https://images.unsplash.com/photo-1619767886558-efdc259cde1a',
    },
    {
      'type': 'BUS',
      'name': 'University Bus',
      'seats': '32 Seats',
      'transmission': 'Automatic',
      'location': 'Main Campus',
      'image': 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e',
    },
    {
      'type': 'SEDAN',
      'name': 'Nissan Sunny',
      'seats': '5 Seats',
      'transmission': 'Automatic',
      'location': 'East Campus',
      'image': 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2',
    },
    {
      'type': 'SUV',
      'name': 'Toyota Land Cruiser',
      'seats': '7 Seats',
      'transmission': 'Automatic',
      'location': 'Main Campus',
      'image': 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 24),

                      _buildSummaryCards(),

                      const SizedBox(height: 24),

                      _buildFilters(),

                      const SizedBox(height: 24),

                      _buildVehicleSection(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Vehicle Catalog',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Browse available fleet vehicles and make a reservation.',
                style: TextStyle(fontSize: 12, color: Color(0xff667085)),
              ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xffd0d5dd)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline, size: 17, color: Color(0xff475467)),
              SizedBox(width: 6),
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
  // SUMMARY CARDS
  // ============================================================

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 4;

        if (constraints.maxWidth < 900) {
          columns = 2;
        }

        if (constraints.maxWidth < 550) {
          columns = 1;
        }

        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            SummaryCard(
              title: 'Available Vehicles',
              value: '24',
              subtitle: '+ 3 returned today',
              icon: Icons.directions_car_outlined,
            ),
            SummaryCard(
              title: 'My Active Requests',
              value: '1',
              subtitle: 'Request pending',
              icon: Icons.pending_actions_outlined,
            ),
            SummaryCard(
              title: 'Approved Upcoming Trips',
              value: '2',
              subtitle: 'Next: Friday Field Study',
              icon: Icons.calendar_month_outlined,
            ),
            SummaryCard(
              title: 'Completed Trips',
              value: '14',
              subtitle: 'Past 12 months',
              icon: Icons.check_circle_outline,
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Vehicles',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xff182230),
            ),
          ),

          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Vehicle Type',
                    value: vehicleType,
                    items: const ['All Types', 'Sedan', 'SUV', 'Van', 'Bus'],
                    onChanged: (value) {
                      setState(() {
                        vehicleType = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Brand',
                    value: brand,
                    items: const [
                      'All Brands',
                      'Toyota',
                      'Hyundai',
                      'Mercedes-Benz',
                      'Nissan',
                    ],
                    onChanged: (value) {
                      setState(() {
                        brand = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Seating Capacity',
                    value: seats,
                    items: const [
                      'Any Capacity',
                      '5 Seats',
                      '7 Seats',
                      '9 Seats',
                      '12 Seats',
                      '32 Seats',
                    ],
                    onChanged: (value) {
                      setState(() {
                        seats = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Powertrain',
                    value: powertrain,
                    items: const [
                      'All Powertrains',
                      'Gasoline',
                      'Diesel',
                      'Electric',
                      'Hybrid',
                    ],
                    onChanged: (value) {
                      setState(() {
                        powertrain = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Transmission',
                    value: transmission,
                    items: const ['Automatic Only', 'Manual', 'Automatic'],
                    onChanged: (value) {
                      setState(() {
                        transmission = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 150,
                  child: _filterDropdown(
                    label: 'Accessibility',
                    value: accessibility,
                    items: const ['Standard / Any', 'Accessible'],
                    onChanged: (value) {
                      setState(() {
                        accessibility = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Color(0xff344054),
          ),
        ),

        const SizedBox(height: 5),

        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 16),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xffd0d5dd)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xffd0d5dd)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xff2864e8)),
            ),
          ),
          style: const TextStyle(fontSize: 9, color: Color(0xff344054)),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ============================================================
  // VEHICLES
  // ============================================================

  Widget _buildVehicleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'Available Vehicles',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff182230),
                ),
              ),
            ),
            Text(
              '24 vehicles found',
              style: TextStyle(fontSize: 10, color: Color(0xff667085)),
            ),
          ],
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            int columns = 3;

            if (constraints.maxWidth < 900) {
              columns = 2;
            }

            if (constraints.maxWidth < 600) {
              columns = 1;
            }

            return GridView.builder(
              itemCount: vehicles.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 365,
              ),
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];

                return VehicleCard(
                  type: vehicle['type']!,
                  name: vehicle['name']!,
                  seats: vehicle['seats']!,
                  transmission: vehicle['transmission']!,
                  location: vehicle['location']!,
                  imageUrl: vehicle['image']!,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../models/driver_model.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  static const DriverModel driver = DriverModel(
    id: 'DRV-4091',
    name: 'Mazen',
    employeeId: 'DRV-4091',
    role: 'Senior Campus Fleet Driver',
    department: 'Central Campus Logistics Depot',
    location: 'Central Campus Logistics Depot',
    shift: 'Morning / Midday (07:00 - 15:30)',
    completedTrips: 142,
    safetyRating: '9.8 / 10',
    currentVehicle: 'Toyota Hiace',

    licenseNumber: '••••-CLD-7741-TX',
    licenseType: 'Commercial Class B • Passenger Transport & Van Endorsed',
    endorsements: 'Authorizes multi-passenger shuttle + transit vans',
    licenseExpiry: 'November 18, 2027',
    licenseIssueDate: 'November 18, 2021',
    issuingAuthority: 'State Dept. of Public Safety (DPS)',

    assignedVehicle: 'Toyota Hiace Commuter',
    vehiclePlate: 'UCF-8820',
    vehicleYear: '2024 Passenger Van',
    vehicleCapacity: '12-Seat Capacity',
    keyStatus: 'Active Key #4',

    backgroundCheckStatus: 'Cleared & Approved',
    backgroundCheckDetails: 'Annual review valid through Sep 2026',
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < 850;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff101828),
                ),
              ),
              const SizedBox(height: 15),
              _buildDriverHeader(mobile),
              const SizedBox(height: 14),
              _buildDriverInformation(mobile),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDriverHeader(bool mobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: mobile
          ? Column(
              children: [
                _buildIdentity(),
                const SizedBox(height: 12),
                _buildStats(),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 4, child: _buildIdentity()),
                const SizedBox(width: 15),
                Expanded(flex: 6, child: _buildStats()),
              ],
            ),
    );
  }

  Widget _buildIdentity() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xffeef4ff),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.person, size: 28, color: Color(0xff667085)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    driver.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff182230),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _activeBadge(),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '#${driver.employeeId}',
                style: const TextStyle(fontSize: 8, color: Color(0xff155eef)),
              ),
              const SizedBox(height: 4),
              Text(
                driver.role,
                style: const TextStyle(fontSize: 8, color: Color(0xff667085)),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 9,
                    color: Color(0xff667085),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      driver.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xff667085),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    size: 9,
                    color: Color(0xff667085),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    driver.shift,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard('Completed Trips', '${driver.completedTrips}'),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: _statCard(
            'Safety Rating',
            driver.safetyRating,
            badge: 'Top 5% Campus Fleet',
          ),
        ),
        const SizedBox(width: 7),
        Expanded(child: _statCard('Current Vehicle', driver.currentVehicle)),
      ],
    );
  }

  Widget _statCard(String title, String value, {String? badge}) {
    return Container(
      height: 67,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fc),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffeaecf0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 6, color: Color(0xff667085)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xff182230),
            ),
          ),
          if (badge != null) ...[
            const SizedBox(height: 2),
            Text(
              badge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 5,
                fontWeight: FontWeight.w600,
                color: Color(0xffb54708),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDriverInformation(bool mobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver Information',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff182230),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Commercial licensing, certifications, and vehicle assignment',
                      style: TextStyle(fontSize: 7, color: Color(0xff667085)),
                    ),
                  ],
                ),
              ),
              _verifiedBadge(),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xffd9deeb)),
          const SizedBox(height: 12),
          if (mobile)
            Column(
              children: [
                _buildLicenseNumber(),
                const SizedBox(height: 8),
                _buildLicenseType(),
                const SizedBox(height: 8),
                _buildDateCards(),
                const SizedBox(height: 8),
                _buildAuthority(),
                const SizedBox(height: 8),
                _buildVehicleAssigned(),
                const SizedBox(height: 8),
                _buildBackgroundCheck(),
              ],
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildLicenseNumber()),
                    const SizedBox(width: 9),
                    Expanded(child: _buildLicenseType()),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildDateCards()),
                    const SizedBox(width: 9),
                    Expanded(child: _buildAuthority()),
                  ],
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(child: _buildVehicleAssigned()),
                    const SizedBox(width: 9),
                    Expanded(child: _buildBackgroundCheck()),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLicenseNumber() {
    return _InfoCard(
      title: 'LICENSE NUMBER',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.licenseNumber,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Official Texas DPS Record',
            style: TextStyle(fontSize: 6, color: Color(0xff667085)),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseType() {
    return _InfoCard(
      title: 'LICENSE TYPE & ENDORSEMENTS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.licenseType,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            driver.endorsements,
            style: const TextStyle(fontSize: 6, color: Color(0xff667085)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCards() {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            title: 'LICENSE EXPIRY DATE',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.licenseExpiry,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff344054),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Valid 24 mo',
                  style: TextStyle(
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff027a48),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Next renewal test: Fall 2027',
                  style: TextStyle(fontSize: 5, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: _InfoCard(
            title: 'ISSUE DATE',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.licenseIssueDate,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff344054),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Tenure: 4 Years Campus Service',
                  style: TextStyle(fontSize: 6, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthority() {
    return _InfoCard(
      title: 'ISSUING AUTHORITY',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driver.issuingAuthority,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Institutional Transportation Regulatory Division',
            style: TextStyle(fontSize: 6, color: Color(0xff667085)),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleAssigned() {
    return _InfoCard(
      icon: Icons.directions_car_outlined,
      title: 'VEHICLE ASSIGNED',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${driver.assignedVehicle} (Plate: ${driver.vehiclePlate})',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff344054),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${driver.vehicleYear} • ${driver.vehicleCapacity}',
                  style: const TextStyle(fontSize: 6, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xffecfdf3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              driver.keyStatus,
              style: const TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w600,
                color: Color(0xff027a48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCheck() {
    return _InfoCard(
      icon: Icons.verified_user_outlined,
      title: 'MVR BACKGROUND CHECK',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.backgroundCheckStatus,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff344054),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  driver.backgroundCheckDetails,
                  style: const TextStyle(fontSize: 6, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xffecfdf3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'No Violations',
              style: TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w600,
                color: Color(0xff027a48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xffecfdf3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, size: 5, color: Color(0xff12b76a)),
          SizedBox(width: 3),
          Text(
            'Active / On Duty',
            style: TextStyle(
              fontSize: 5,
              fontWeight: FontWeight.w600,
              color: Color(0xff027a48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffecfdf3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline, size: 10, color: Color(0xff027a48)),
          SizedBox(width: 3),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w600,
              color: Color(0xff027a48),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;

  const _InfoCard({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xfff8f9fc),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 10, color: const Color(0xff667085)),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 6,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff667085),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }
}

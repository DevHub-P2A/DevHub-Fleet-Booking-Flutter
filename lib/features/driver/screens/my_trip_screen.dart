import 'package:flutter/material.dart';

import '../models/driver_trip_model.dart';

class MyTripScreen extends StatelessWidget {
  const MyTripScreen({super.key});

  static const DriverTripModel trip = DriverTripModel(
    tripId: '#TRP-8820',
    status: 'Assigned • Scheduled',
    origin: 'Central Campus - Gate 2',
    originDetails: 'Fleet Logistics Department',
    departureTime: '08:30 AM Departure',
    destination: 'Pine Ridge Field Station',
    destinationDetails: 'Forestry Research Laboratory',
    estimatedArrival: 'Est. Arrival 09:05 AM',
    vehicleName: 'Toyota Hiace Commuter',
    plateNumber: 'UCF-8820',
    seats: 12,
    fuel: '88% Fuel',
    odometer: '34,566 km',
    passengerCount: 8,
    tripLead: 'Prof. Sarah Jenkins',
    department: 'Bio Sciences Dept',
    vehicleStatus: 'Vehicle Ready to Depart',
    currentLocation: 'Approaching Mountain Spur Junction',
    speed: '54 km/h',
    distance: '38.4 km',
    estimatedTime: '32 mins',
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
              _buildPageHeader(mobile),
              const SizedBox(height: 16),
              if (mobile)
                Column(
                  children: [
                    _buildTripCard(),
                    const SizedBox(height: 12),
                    _buildMapCard(),
                    const SizedBox(height: 12),
                    _buildStartCard(context),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _buildTripCard(),
                          const SizedBox(height: 12),
                          _buildStartCard(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(flex: 4, child: _buildMapCard()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageHeader(bool mobile) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'My Trip',
            style: TextStyle(
              fontSize: mobile ? 20 : 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xff101828),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xffeef4ff),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 6, color: Color(0xff155eef)),
              SizedBox(width: 4),
              Text(
                'Driver',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff155eef),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Trip ${trip.tripId}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff182230),
                      ),
                    ),
                    const SizedBox(width: 7),
                    _statusBadge(trip.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          const Divider(height: 1, color: Color(0xffd9deeb)),
          const SizedBox(height: 14),
          _buildRoute(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildVehicleInfo()),
              const SizedBox(width: 10),
              Expanded(child: _buildManifestInfo()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoute() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xffeef4ff),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.circle,
                size: 8,
                color: Color(0xff155eef),
              ),
            ),
            Container(width: 1, height: 38, color: const Color(0xffd0d5dd)),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xffeef4ff),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_on,
                size: 10,
                color: Color(0xff155eef),
              ),
            ),
          ],
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ORIGIN',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff667085),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trip.origin,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff344054),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trip.originDetails,
                style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
              ),
              const SizedBox(height: 3),
              Text(
                trip.departureTime,
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff155eef),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DESTINATION',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff667085),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trip.destination,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff344054),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trip.destinationDetails,
                  style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
                ),
                const SizedBox(height: 3),
                Text(
                  trip.estimatedArrival,
                  style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleInfo() {
    return _InfoBox(
      title: 'ASSIGNED VEHICLE',
      icon: Icons.directions_car_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.vehicleName,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: [
              _smallTag('Plate: ${trip.plateNumber}'),
              _smallTag('${trip.seats} Seats'),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Icon(
                Icons.local_gas_station_outlined,
                size: 10,
                color: Color(0xff027a48),
              ),
              const SizedBox(width: 3),
              Text(
                trip.fuel,
                style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.speed_outlined,
                size: 10,
                color: Color(0xff667085),
              ),
              const SizedBox(width: 3),
              Text(
                trip.odometer,
                style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManifestInfo() {
    return _InfoBox(
      title: 'MANIFEST & LEAD',
      icon: Icons.groups_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${trip.passengerCount} Passengers',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const CircleAvatar(
                radius: 8,
                backgroundColor: Color(0xffe0ebff),
                child: Text(
                  'SJ',
                  style: TextStyle(
                    fontSize: 5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff155eef),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  trip.tripLead,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            trip.department,
            style: const TextStyle(fontSize: 7, color: Color(0xff667085)),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 10,
                color: Color(0xff155eef),
              ),
              const SizedBox(width: 3),
              const Text(
                'Call Lead',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff155eef),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trip.vehicleStatus,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xff182230),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              onPressed: () {
                _showStartTripDialog(context);
              },
              icon: const Icon(Icons.play_circle_outline, size: 16),
              label: const Text(
                'Start Trip',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xff2864e8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      width: double.infinity,
      height: 353,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffd9deeb))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 13,
                  color: Color(0xff155eef),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'Trip Route & Live Location',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff344054),
                    ),
                  ),
                ),
                _mapButton(Icons.my_location),
                _mapButton(Icons.add),
                _mapButton(Icons.remove),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                CustomPaint(
                  painter: _MapPainter(),
                  child: const SizedBox.expand(),
                ),
                Positioned(top: 10, left: 10, child: _mapInfoChip()),
                Positioned(top: 12, right: 10, child: _destinationChip()),
                Positioned(
                  left: 18,
                  bottom: 52,
                  child: _locationLabel('START', 'Depot Gate 2'),
                ),
                Positioned(
                  right: 12,
                  bottom: 105,
                  child: _locationLabel('DESTINATION', 'Pine Ridge Station'),
                ),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: const Text(
                    'Turn-by-turn preview',
                    style: TextStyle(
                      fontSize: 6,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff667085),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xffd9deeb))),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.navigation_outlined,
                  size: 13,
                  color: Color(0xff344054),
                ),
                const SizedBox(width: 5),
                const Expanded(
                  child: Text(
                    'In 1.2 km, turn right onto Mountain Spur Road',
                    maxLines: 2,
                    style: TextStyle(fontSize: 7, color: Color(0xff344054)),
                  ),
                ),
                Text(
                  trip.speed,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon) {
    return Container(
      width: 21,
      height: 21,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffd0d5dd)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 11, color: const Color(0xff667085)),
    );
  }

  Widget _mapInfoChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Color(0x18000000))],
      ),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xff027a48)),
          const SizedBox(width: 4),
          const Text(
            'Vehicle UCF-8820',
            style: TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w700,
              color: Color(0xff344054),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            trip.speed,
            style: const TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w700,
              color: Color(0xff155eef),
            ),
          ),
        ],
      ),
    );
  }

  Widget _destinationChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(blurRadius: 5, color: Color(0x18000000))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'DESTINATION',
            style: TextStyle(
              fontSize: 5,
              fontWeight: FontWeight.w700,
              color: Color(0xffe5484d),
            ),
          ),
          Text(
            'Pine Ridge Station',
            style: TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w600,
              color: Color(0xff344054),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationLabel(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Color(0x16000000))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 5,
              fontWeight: FontWeight.w700,
              color: title == 'DESTINATION'
                  ? const Color(0xffe5484d)
                  : const Color(0xff155eef),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w600,
              color: Color(0xff344054),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffeef4ff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.w600,
          color: Color(0xff155eef),
        ),
      ),
    );
  }

  Widget _smallTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xfff2f4f7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 6, color: Color(0xff667085)),
      ),
    );
  }

  void _showStartTripDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Start Trip',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'The trip is ready to start. The actual trip status will be updated through the Backend.',
            style: TextStyle(fontSize: 12, color: Color(0xff667085)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoBox({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, size: 10, color: const Color(0xff667085)),
              const SizedBox(width: 4),
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

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint background = Paint()..color = const Color(0xffeef4ef);

    canvas.drawRect(Offset.zero & size, background);

    final Paint roads = Paint()
      ..color = const Color(0xffd0d5dd)
      ..strokeWidth = 1;

    for (double x = 20; x < size.width; x += 55) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roads);
    }

    for (double y = 25; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roads);
    }

    final Paint route = Paint()
      ..color = const Color(0xff2864e8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    path.moveTo(size.width * .20, size.height * .75);

    path.cubicTo(
      size.width * .35,
      size.height * .70,
      size.width * .38,
      size.height * .48,
      size.width * .55,
      size.height * .48,
    );

    path.cubicTo(
      size.width * .70,
      size.height * .48,
      size.width * .68,
      size.height * .28,
      size.width * .82,
      size.height * .20,
    );

    canvas.drawPath(path, route);

    final Paint startPaint = Paint()..color = const Color(0xff155eef);

    canvas.drawCircle(
      Offset(size.width * .20, size.height * .75),
      6,
      startPaint,
    );

    final Paint destinationPaint = Paint()..color = const Color(0xffe5484d);

    canvas.drawCircle(
      Offset(size.width * .82, size.height * .20),
      6,
      destinationPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

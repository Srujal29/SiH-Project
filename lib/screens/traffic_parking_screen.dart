import 'package:flutter/material.dart';
import 'package:devadarshan/services/mock_data_service.dart';

class TrafficParkingScreen extends StatefulWidget {
  const TrafficParkingScreen({super.key});

  @override
  State<TrafficParkingScreen> createState() => _TrafficParkingScreenState();
}

class _TrafficParkingScreenState extends State<TrafficParkingScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final parkingData = MockDataService.getParkingData();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic & Parking'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onSecondary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.7),
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Parking', icon: Icon(Icons.local_parking)),
            Tab(text: 'Traffic', icon: Icon(Icons.traffic)),
            Tab(text: 'Transport', icon: Icon(Icons.directions_bus)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildParkingTab(),
          _buildTrafficTab(),
          _buildTransportTab(),
        ],
      ),
    );
  }

  Widget _buildParkingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParkingOverview(),
          const SizedBox(height: 24),
          _buildParkingAreas(),
          const SizedBox(height: 24),
          _buildParkingTips(),
        ],
      ),
    );
  }

  Widget _buildParkingOverview() {
    int totalSpots = 0;
    int occupiedSpots = 0;
    
    for (var area in parkingData) {
      totalSpots += area['totalSpots'] as int;
      occupiedSpots += area['occupiedSpots'] as int;
    }
    
    double occupancyRate = occupiedSpots / totalSpots;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Live Parking Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildParkingStatItem('Available', '${totalSpots - occupiedSpots}', Colors.green),
                _buildParkingStatItem('Occupied', '$occupiedSpots', Colors.red),
                _buildParkingStatItem('Total', '$totalSpots', Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: occupancyRate,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                occupancyRate > 0.8 ? Colors.red : occupancyRate > 0.6 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(occupancyRate * 100).round()}% Full',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildParkingAreas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Parking Areas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parkingData.length,
          itemBuilder: (context, index) {
            final area = parkingData[index];
            final occupancyRate = (area['occupiedSpots'] as int) / (area['totalSpots'] as int);
            final availableSpots = (area['totalSpots'] as int) - (area['occupiedSpots'] as int);
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getParkingStatusColor(occupancyRate).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.local_parking,
                            color: _getParkingStatusColor(occupancyRate),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                area['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(area['distance']),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: area['type'] == 'Free' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            area['type'],
                            style: TextStyle(
                              color: area['type'] == 'Free' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available: $availableSpots spots'),
                        Text('${(occupancyRate * 100).round()}% full'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: occupancyRate,
                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(_getParkingStatusColor(occupancyRate)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showDirections(area['name']),
                            icon: const Icon(Icons.directions, size: 16),
                            label: const Text('Get Directions'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (area['type'] == 'Paid')
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showParkingBooking(area),
                              icon: const Icon(Icons.book_online, size: 16),
                              label: const Text('Book Spot'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildParkingTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Parking Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('• Arrive early during festival days for better spots'),
            const Text('• VIP parking available for elderly and disabled'),
            const Text('• Shuttle service available from overflow parking'),
            const Text('• Keep parking receipt for security verification'),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrafficStatus(),
          const SizedBox(height: 24),
          _buildRouteRecommendations(),
          const SizedBox(height: 24),
          _buildTrafficAlerts(),
        ],
      ),
    );
  }

  Widget _buildTrafficStatus() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blue.withValues(alpha: 0.8)],
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.traffic, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              'Current Traffic Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'MODERATE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Average delay: 15-20 minutes',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteRecommendations() {
    final routes = [
      {'name': 'Main Highway Route', 'time': '25 min', 'status': 'Clear', 'color': Colors.green},
      {'name': 'City Center Route', 'time': '35 min', 'status': 'Busy', 'color': Colors.orange},
      {'name': 'Bypass Route', 'time': '40 min', 'status': 'Heavy', 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Routes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final route = routes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (route['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.route,
                    color: route['color'] as Color,
                  ),
                ),
                title: Text(
                  route['name'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Est. time: ${route['time']}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (route['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    route['status'] as String,
                    style: TextStyle(
                      color: route['color'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                onTap: () => _showRouteDetails(route),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrafficAlerts() {
    final alerts = [
      '🚧 Construction work on Temple Road - Expect 10 min delay',
      '🚗 Heavy traffic near main entrance - Use alternative routes',
      '⚠️ VIP movement expected at 3 PM - Plan accordingly',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Traffic Alerts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...alerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(alert),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShuttleService(),
          const SizedBox(height: 24),
          _buildPublicTransport(),
          const SizedBox(height: 24),
          _buildTaxiServices(),
        ],
      ),
    );
  }

  Widget _buildShuttleService() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_bus, color: Theme.of(context).colorScheme.primary, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Temple Shuttle Service',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Every 15 minutes',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Route: Railway Station → Temple → Overflow Parking'),
                  const Text('Timing: 5:00 AM - 10:00 PM'),
                  const Text('Cost: Free for pilgrims'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showShuttleTracker(),
                    icon: const Icon(Icons.my_location),
                    label: const Text('Track Shuttle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showShuttleSchedule(),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Full Schedule'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicTransport() {
    final transports = [
      {'type': 'Bus', 'route': 'City Bus Route 42', 'frequency': '20 min', 'cost': '₹15'},
      {'type': 'Auto', 'route': 'Station to Temple', 'frequency': 'On demand', 'cost': '₹50-80'},
      {'type': 'Taxi', 'route': 'App-based cabs', 'frequency': '2-5 min', 'cost': '₹100-150'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Public Transport Options',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transports.length,
          itemBuilder: (context, index) {
            final transport = transports[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    _getTransportIcon(transport['type']!),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(transport['type']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transport['route']!),
                    Text('Frequency: ${transport['frequency']}'),
                  ],
                ),
                trailing: Text(
                  transport['cost']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTaxiServices() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_taxi, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Taxi & Cab Services',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('📱 Book via apps: Ola, Uber, Rapido'),
            const Text('📞 Local taxi: +91 9999-TAXI-01'),
            const Text('💰 Estimated fare: ₹100-200 from station'),
            const Text('⏰ Peak hour surcharge may apply'),
          ],
        ),
      ),
    );
  }

  Color _getParkingStatusColor(double occupancyRate) {
    if (occupancyRate > 0.8) return Colors.red;
    if (occupancyRate > 0.6) return Colors.orange;
    return Colors.green;
  }

  IconData _getTransportIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bus': return Icons.directions_bus;
      case 'auto': return Icons.directions;
      case 'taxi': return Icons.local_taxi;
      default: return Icons.directions;
    }
  }

  void _showDirections(String areaName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening directions to $areaName...')),
    );
  }

  void _showParkingBooking(Map<String, dynamic> area) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book Parking - ${area['name']}'),
        content: Text('Would you like to reserve a parking spot?\nCost: ₹50 for full day'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Parking spot reserved successfully!')),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _showRouteDetails(Map<String, dynamic> route) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening navigation for ${route['name']}...')),
    );
  }

  void _showShuttleTracker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening live shuttle tracker...')),
    );
  }

  void _showShuttleSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening full shuttle schedule...')),
    );
  }
}
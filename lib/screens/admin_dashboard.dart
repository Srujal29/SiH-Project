import 'package:flutter/material.dart';
import 'package:devadarshan/services/mock_data_service.dart';
import 'package:devadarshan/models/temple.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  final crowdData = MockDataService.getCrowdAnalytics();
  final temples = MockDataService.getTemples();
  final emergencyAlerts = MockDataService.getEmergencyAlerts();

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
        title: const Text('Admin Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: const [
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
            Tab(text: 'Heatmap', icon: Icon(Icons.map)),
            Tab(text: 'Alerts', icon: Icon(Icons.warning)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnalyticsTab(),
          _buildHeatmapTab(),
          _buildAlertsTab(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsOverview(),
          const SizedBox(height: 24),
          _buildPredictionCard(),
          const SizedBox(height: 24),
          _buildTempleStatusCards(),
          const SizedBox(height: 24),
          _buildStaffSuggestions(),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Today\'s Visitors',
          '${crowdData['todayVisitors']}',
          Icons.people,
          Theme.of(context).colorScheme.primary,
          '+12% from yesterday',
        ),
        _buildStatCard(
          'Weekly Average',
          '${crowdData['weeklyAverage']}',
          Icons.trending_up,
          Theme.of(context).colorScheme.secondary,
          'Steady growth',
        ),
        _buildStatCard(
          'Peak Hours',
          '${(crowdData['peakHours'] as List)[0]}',
          Icons.schedule,
          Theme.of(context).colorScheme.tertiary,
          'Morning rush',
        ),
        _buildStatCard(
          'Active Temples',
          '${temples.length}',
          Icons.temple_hindu,
          Colors.green,
          'All operational',
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(Icons.trending_up, color: color, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    final prediction = crowdData['prediction'] as Map<String, dynamic>;
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
                Icon(Icons.psychology, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'AI Crowd Prediction',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tomorrow\'s Forecast: ${prediction['tomorrow']} visitors',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Confidence: ${prediction['confidence']}%'),
                  const SizedBox(height: 12),
                  Text(
                    'Key Factors:',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  ...((prediction['factors'] as List).map((factor) => 
                    Text('• $factor', style: Theme.of(context).textTheme.bodyMedium)
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempleStatusCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temple Status Overview',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: temples.length,
          itemBuilder: (context, index) {
            final temple = temples[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getCrowdColor(temple.crowdPercentage).withValues(alpha: 0.2),
                  child: Text(
                    '${(temple.crowdPercentage * 100).round()}%',
                    style: TextStyle(
                      color: _getCrowdColor(temple.crowdPercentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                title: Text(temple.name),
                subtitle: Text('${temple.currentCrowd}/${temple.maxCapacity} pilgrims'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      temple.isOpen ? Icons.check_circle : Icons.cancel,
                      color: temple.isOpen ? Colors.green : Colors.red,
                    ),
                    Text(
                      temple.isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        fontSize: 12,
                        color: temple.isOpen ? Colors.green : Colors.red,
                      ),
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

  Widget _buildStaffSuggestions() {
    final suggestions = [
      'Increase security at Somnath Temple - High crowd expected',
      'Deploy medical team near Dwarka main entrance',
      'Additional volunteers needed at parking area',
      'Setup overflow seating in Ambaji courtyard',
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'AI Staff Deployment Suggestions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(suggestion)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapTab() {
    final heatMapData = crowdData['heatMapData'] as List;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time Crowd Density Heatmap',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Temple Layout View',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: heatMapData.length,
                    itemBuilder: (context, index) {
                      final area = heatMapData[index];
                      final density = area['density'] as int;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getHeatmapColor(density),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              area['area'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$density%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildHeatmapLegend(),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: heatMapData.length,
            itemBuilder: (context, index) {
              final area = heatMapData[index];
              final density = area['density'] as int;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(density),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$density%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  title: Text(area['area']),
                  subtitle: Text('${_getDensityStatus(density)} density'),
                  trailing: Icon(
                    _getDensityIcon(density),
                    color: _getHeatmapColor(density),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Density Legend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Low', Colors.green, '0-30%'),
                _buildLegendItem('Medium', Colors.orange, '31-70%'),
                _buildLegendItem('High', Colors.red, '71-100%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(range, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildAlertsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: emergencyAlerts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Emergency Alerts & Incidents',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        
        final alert = emergencyAlerts[index - 1];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getAlertColor(alert.status).withValues(alpha: 0.2),
              child: Icon(
                _getAlertIcon(alert.type),
                color: _getAlertColor(alert.status),
              ),
            ),
            title: Text(
              alert.type,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.description),
                const SizedBox(height: 4),
                Text('📍 ${alert.location}'),
                Text('🕒 ${_formatTime(alert.timestamp)}'),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getAlertColor(alert.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                alert.status.name.toUpperCase(),
                style: TextStyle(
                  color: _getAlertColor(alert.status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getCrowdColor(double percentage) {
    if (percentage < 0.3) return Colors.green;
    if (percentage < 0.7) return Colors.orange;
    return Colors.red;
  }

  Color _getHeatmapColor(int density) {
    if (density <= 30) return Colors.green;
    if (density <= 70) return Colors.orange;
    return Colors.red;
  }

  String _getDensityStatus(int density) {
    if (density <= 30) return 'Low';
    if (density <= 70) return 'Medium';
    return 'High';
  }

  IconData _getDensityIcon(int density) {
    if (density <= 30) return Icons.sentiment_satisfied;
    if (density <= 70) return Icons.sentiment_neutral;
    return Icons.sentiment_dissatisfied;
  }

  Color _getAlertColor(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.active: return Colors.red;
      case EmergencyStatus.responding: return Colors.orange;
      case EmergencyStatus.resolved: return Colors.green;
    }
  }

  IconData _getAlertIcon(String type) {
    if (type.toLowerCase().contains('medical')) return Icons.local_hospital;
    if (type.toLowerCase().contains('crowd')) return Icons.groups;
    return Icons.warning;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
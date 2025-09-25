import 'package:flutter/material.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> with TickerProviderStateMixin {
  bool isEmergencyActive = false;
  String? selectedEmergencyType;
  final _descriptionController = TextEditingController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> emergencyTypes = [
    {'type': 'Medical Emergency', 'icon': Icons.local_hospital, 'color': Colors.red},
    {'type': 'Crowd Control', 'icon': Icons.groups, 'color': Colors.orange},
    {'type': 'Fire Emergency', 'icon': Icons.local_fire_department, 'color': Colors.deepOrange},
    {'type': 'Security Issue', 'icon': Icons.security, 'color': Colors.purple},
    {'type': 'Lost Person', 'icon': Icons.person_search, 'color': Colors.blue},
    {'type': 'Other Emergency', 'icon': Icons.warning, 'color': Colors.amber},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
      ),
      body: isEmergencyActive ? _buildEmergencyActiveView() : _buildEmergencyForm(),
    );
  }

  Widget _buildEmergencyForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Large Emergency Button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: GestureDetector(
                  onTap: _activateEmergency,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.emergency,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'SOS',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          
          Text(
            'Tap the button above for immediate emergency response',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Emergency Type Selection
          Text(
            'Select Emergency Type (Optional)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: emergencyTypes.length,
            itemBuilder: (context, index) {
              final emergency = emergencyTypes[index];
              final isSelected = selectedEmergencyType == emergency['type'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedEmergencyType = isSelected ? null : emergency['type'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? emergency['color'].withValues(alpha: 0.2)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? emergency['color'] 
                          : Colors.grey.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        emergency['icon'],
                        color: emergency['color'],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          emergency['type'],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          
          // Additional Details
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Additional Details (Optional)',
              hintText: 'Describe the emergency situation...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 40),
          
          // Quick Access Numbers
          _buildQuickAccessCard(),
        ],
      ),
    );
  }

  Widget _buildEmergencyActiveView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 32),
          
          Text(
            'Emergency Alert Sent!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Help is on the way',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your location: Somnath Temple - Main Gate',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Response team ETA: 3-5 minutes',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.local_hospital,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nearest medical facility: 200m away',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Status Updates
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Live Updates',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildStatusUpdate('Emergency team dispatched', '1 min ago', true),
                _buildStatusUpdate('Medical team en route', '2 min ago', true),
                _buildStatusUpdate('Security alerted', '3 min ago', true),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () {
              setState(() => isEmergencyActive = false);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Return to Safety'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Access Numbers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildQuickAccessNumber('Temple Security', '+91 100', Icons.security),
            _buildQuickAccessNumber('Medical Emergency', '+91 108', Icons.local_hospital),
            _buildQuickAccessNumber('Police', '+91 100', Icons.local_police),
            _buildQuickAccessNumber('Fire Department', '+91 101', Icons.local_fire_department),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessNumber(String service, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(number, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showCallDialog(service, number),
            icon: const Icon(Icons.call),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusUpdate(String message, String time, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _activateEmergency() {
    // In a real app, this would send GPS location, user details, and emergency type
    setState(() => isEmergencyActive = true);
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🚨 Emergency alert sent! Help is coming.'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showCallDialog(String service, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call $service?'),
        content: Text('This will call $number'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $service...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}
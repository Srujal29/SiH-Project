import 'package:flutter/material.dart';
import 'package:devadarshan/models/temple.dart';
import 'package:devadarshan/services/mock_data_service.dart';

class LostFoundScreen extends StatefulWidget {
  const LostFoundScreen({super.key});

  @override
  State<LostFoundScreen> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<LostFoundScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  String selectedItemType = 'Person';
  final List<String> itemTypes = ['Person', 'Item', 'Document', 'Jewelry', 'Electronics', 'Other'];
  
  List<LostFoundItem> lostItems = [];
  bool isReportSubmitted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    lostItems = MockDataService.getLostFoundItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: const [
            Tab(text: 'Report', icon: Icon(Icons.report)),
            Tab(text: 'Search', icon: Icon(Icons.search)),
            Tab(text: 'Found Items', icon: Icon(Icons.inventory)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isReportSubmitted ? _buildReportConfirmation() : _buildReportForm(),
          _buildSearchTab(),
          _buildFoundItemsTab(),
        ],
      ),
    );
  }

  Widget _buildReportForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Lost Person/Item',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Item Type Selection
            Text(
              'What did you lose?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedItemType,
                isExpanded: true,
                underline: const SizedBox(),
                items: itemTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getItemTypeIcon(type), size: 20),
                      const SizedBox(width: 8),
                      Text(type),
                    ],
                  ),
                )).toList(),
                onChanged: (value) => setState(() => selectedItemType = value!),
              ),
            ),
            const SizedBox(height: 20),
            
            // Personal Details
            Text(
              'Your Contact Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Full Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty == true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty == true ? 'Please enter your phone number' : null,
            ),
            const SizedBox(height: 20),
            
            // Lost Item Details
            Text(
              selectedItemType == 'Person' ? 'Person Details' : 'Item Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: selectedItemType == 'Person' 
                    ? 'Describe the person (age, clothing, etc.)' 
                    : 'Describe the item (color, brand, size, etc.)',
                prefixIcon: const Icon(Icons.description),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value?.isEmpty == true ? 'Please provide a description' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Last seen location',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                hintText: 'e.g., Main temple entrance, parking area',
              ),
              validator: (value) => value?.isEmpty == true ? 'Please specify the location' : null,
            ),
            const SizedBox(height: 24),
            
            // Priority Alert
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: selectedItemType == 'Person' 
                    ? Colors.red.withValues(alpha: 0.1) 
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selectedItemType == 'Person' ? Colors.red : Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selectedItemType == 'Person' ? Icons.priority_high : Icons.info_outline,
                    color: selectedItemType == 'Person' ? Colors.red : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedItemType == 'Person' 
                          ? 'Missing person reports are treated with highest priority and will be immediately broadcasted to security personnel.'
                          : 'Your report will be shared with temple staff and volunteers to help locate your item.',
                      style: TextStyle(
                        color: selectedItemType == 'Person' ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.send),
                label: Text('Submit ${selectedItemType == 'Person' ? 'Missing Person' : 'Lost Item'} Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: selectedItemType == 'Person' 
                      ? Colors.red 
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportConfirmation() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          ),
          const SizedBox(height: 24),
          Text(
            'Report Submitted Successfully!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            selectedItemType == 'Person'
                ? 'Missing person alert has been sent to all security personnel and volunteers.'
                : 'Your lost item report has been shared with temple staff.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What happens next?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNextStepItem('📢 Broadcast sent to all staff', 'Immediate'),
                  _buildNextStepItem('👥 Volunteers alerted in area', '2-3 minutes'),
                  _buildNextStepItem('📱 You\'ll receive updates via SMS', 'As available'),
                  _buildNextStepItem('🔍 Active search begins', 'Ongoing'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Return to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String step, String timing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step),
                Text(
                  timing,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Lost & Found Items',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by description, type, or location...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // In a real app, this would filter the results
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Reports',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lostItems.length,
            itemBuilder: (context, index) {
              final item = lostItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(item.status).withValues(alpha: 0.2),
                    child: Icon(
                      _getItemTypeIcon(item.type),
                      color: _getStatusColor(item.status),
                    ),
                  ),
                  title: Text(
                    '${item.type}: ${item.description}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📍 ${item.location}'),
                      Text('👤 Reported by: ${item.reporterName}'),
                      Text('🕒 ${_formatTime(item.timestamp)}'),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.status.name.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(item.status),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoundItemsTab() {
    final foundItems = lostItems.where((item) => item.status == LostFoundStatus.found).toList();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items Waiting for Collection',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (foundItems.isEmpty)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.inbox,
                    size: 80,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No found items waiting for collection',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foundItems.length,
              itemBuilder: (context, index) {
                final item = foundItems[index];
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
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getItemTypeIcon(item.type),
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.type} Found!',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    item.description,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'FOUND',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Collection Information',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text('📍 Location: Temple Lost & Found Counter'),
                              Text('🕒 Hours: 6:00 AM - 9:00 PM daily'),
                              Text('📱 Contact: +91 9999-TEMPLE'),
                              const SizedBox(height: 8),
                              const Text(
                                '⚠️ Please bring valid ID for collection',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() => isReportSubmitted = true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedItemType == 'Person' 
                ? '🚨 Missing person alert broadcasted immediately!'
                : '📢 Lost item report submitted successfully!',
          ),
          backgroundColor: selectedItemType == 'Person' ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  IconData _getItemTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'person': return Icons.person;
      case 'item': return Icons.inventory;
      case 'document': return Icons.description;
      case 'jewelry': return Icons.diamond;
      case 'electronics': return Icons.phone_android;
      default: return Icons.help_outline;
    }
  }

  Color _getStatusColor(LostFoundStatus status) {
    switch (status) {
      case LostFoundStatus.reported: return Colors.orange;
      case LostFoundStatus.searching: return Colors.blue;
      case LostFoundStatus.found: return Colors.green;
      case LostFoundStatus.closed: return Colors.grey;
    }
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
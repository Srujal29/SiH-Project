import 'package:flutter/material.dart';
import 'package:devadarshan/models/temple.dart';
import 'package:devadarshan/services/mock_data_service.dart';

class PilgrimInfoScreen extends StatefulWidget {
  const PilgrimInfoScreen({super.key});

  @override
  State<PilgrimInfoScreen> createState() => _PilgrimInfoScreenState();
}

class _PilgrimInfoScreenState extends State<PilgrimInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final temples = MockDataService.getTemples();
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'हिन्दी', 'ગુજરાતી'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Temple Information'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) => setState(() => selectedLanguage = value),
            itemBuilder: (context) => languages.map((lang) => 
              PopupMenuItem(value: lang, child: Text(lang))
            ).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: Theme.of(context).colorScheme.secondary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Temples', icon: Icon(Icons.temple_hindu)),
            Tab(text: 'Timings', icon: Icon(Icons.schedule)),
            Tab(text: 'Facilities', icon: Icon(Icons.info)),
            Tab(text: 'Guidelines', icon: Icon(Icons.rule)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTemplesTab(),
          _buildTimingsTab(),
          _buildFacilitiesTab(),
          _buildGuidelinesTab(),
        ],
      ),
    );
  }

  Widget _buildTemplesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _translate('Sacred Temples'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              final temple = temples[index];
              return _buildTempleCard(temple);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTempleCard(Temple temple) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              temple.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.temple_hindu,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  temple.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(temple.location, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  temple.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: temple.isOpen ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        temple.isOpen ? _translate('Open') : _translate('Closed'),
                        style: TextStyle(
                          color: temple.isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${temple.currentCrowd}/${temple.maxCapacity}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _translate('Temple Timings & Rituals'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              final temple = temples[index];
              return _buildTimingCard(temple);
            },
          ),
          const SizedBox(height: 24),
          _buildDailyRituals(),
        ],
      ),
    );
  }

  Widget _buildTimingCard(Temple temple) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              temple.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...temple.timings.map((timing) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(timing),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRituals() {
    final rituals = [
      {'time': '5:00 AM', 'ritual': 'Mangala Aarti'},
      {'time': '12:00 PM', 'ritual': 'Madhyana Aarti'},
      {'time': '7:00 PM', 'ritual': 'Sandhya Aarti'},
      {'time': '10:00 PM', 'ritual': 'Shayan Aarti'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.self_improvement, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _translate('Daily Rituals'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...rituals.map((ritual) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ritual['time']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _translate(ritual['ritual']!),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _translate('Temple Facilities'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildFacilitySection(
            _translate('Essential Services'),
            [
              {'icon': Icons.local_hospital, 'name': 'Medical Center', 'description': '24/7 medical assistance'},
              {'icon': Icons.security, 'name': 'Security', 'description': 'CCTV monitoring & guards'},
              {'icon': Icons.wc, 'name': 'Restrooms', 'description': 'Clean facilities available'},
              {'icon': Icons.local_drink, 'name': 'Water Stations', 'description': 'Free drinking water'},
            ],
          ),
          const SizedBox(height: 24),
          _buildFacilitySection(
            _translate('Accessibility'),
            [
              {'icon': Icons.accessible, 'name': 'Wheelchair Access', 'description': 'Ramps and accessible paths'},
              {'icon': Icons.elderly, 'name': 'Senior Citizen Aid', 'description': 'Special assistance available'},
              {'icon': Icons.child_friendly, 'name': 'Baby Care', 'description': 'Feeding and changing rooms'},
              {'icon': Icons.local_parking, 'name': 'Priority Parking', 'description': 'Reserved spots available'},
            ],
          ),
          const SizedBox(height: 24),
          _buildFacilitySection(
            _translate('Convenience'),
            [
              {'icon': Icons.shopping_bag, 'name': 'Prasad Counter', 'description': 'Religious offerings available'},
              {'icon': Icons.restaurant, 'name': 'Food Court', 'description': 'Vegetarian meals'},
              {'icon': Icons.local_atm, 'name': 'ATM', 'description': 'Cash withdrawal facility'},
              {'icon': Icons.wifi, 'name': 'Free WiFi', 'description': 'Internet connectivity'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitySection(String title, List<Map<String, dynamic>> facilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: facilities.length,
          itemBuilder: (context, index) {
            final facility = facilities[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      facility['icon'] as IconData,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _translate(facility['name'] as String),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _translate(facility['description'] as String),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildGuidelinesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _translate('Temple Guidelines'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildGuidelineSection(
            _translate('Do\'s'),
            [
              'Maintain silence and reverence',
              'Dress modestly and appropriately',
              'Remove footwear before entering',
              'Follow queue discipline',
              'Respect photography restrictions',
              'Help elderly and disabled pilgrims',
            ],
            Colors.green,
            Icons.check_circle,
          ),
          const SizedBox(height: 24),
          _buildGuidelineSection(
            _translate('Don\'ts'),
            [
              'No smoking or alcohol consumption',
              'No mobile phone use in prayer halls',
              'No touching of deities or artifacts',
              'No loud conversations',
              'No outside food in temple premises',
              'No inappropriate behavior',
            ],
            Colors.red,
            Icons.cancel,
          ),
          const SizedBox(height: 24),
          _buildEmergencyContacts(),
        ],
      ),
    );
  }

  Widget _buildGuidelineSection(String title, List<String> guidelines, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...guidelines.map((guideline) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6, right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: Text(_translate(guideline))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    final contacts = [
      {'service': 'Temple Security', 'number': '+91 9999-TEMPLE'},
      {'service': 'Medical Emergency', 'number': '+91 108'},
      {'service': 'Lost & Found', 'number': '+91 9999-LOST'},
      {'service': 'General Inquiry', 'number': '+91 9999-INFO'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_phone, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  _translate('Emergency Contacts'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...contacts.map((contact) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _translate(contact['service']!),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        contact['number']!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.call,
                        size: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _translate(String text) {
    // Simple translation mapping for demonstration
    if (selectedLanguage == 'हिन्दी') {
      final translations = {
        'Sacred Temples': 'पवित्र मंदिर',
        'Open': 'खुला',
        'Closed': 'बंद',
        'Temple Timings & Rituals': 'मंदिर का समय और रीति-रिवाज',
        'Daily Rituals': 'दैनिक अनुष्ठान',
        'Mangala Aarti': 'मंगला आरती',
        'Madhyana Aarti': 'मध्याह्न आरती',
        'Sandhya Aarti': 'संध्या आरती',
        'Shayan Aarti': 'शयन आरती',
        'Temple Facilities': 'मंदिर की सुविधाएं',
        'Essential Services': 'आवश्यक सेवाएं',
        'Accessibility': 'पहुंच',
        'Convenience': 'सुविधा',
        'Temple Guidelines': 'मंदिर के नियम',
        'Do\'s': 'करने योग्य',
        'Don\'ts': 'न करें',
        'Emergency Contacts': 'आपातकालीन संपर्क',
      };
      return translations[text] ?? text;
    } else if (selectedLanguage == 'ગુજરાતી') {
      final translations = {
        'Sacred Temples': 'પવિત્ર મંદિરો',
        'Open': 'ખુલ્લું',
        'Closed': 'બંધ',
        'Temple Timings & Rituals': 'મંદિરનો સમય અને રીતરિવાજ',
        'Daily Rituals': 'દૈનિક વિધિઓ',
        'Temple Facilities': 'મંદિરની સુવિધાઓ',
        'Essential Services': 'આવશ્યક સેવાઓ',
        'Accessibility': 'સુલભતા',
        'Convenience': 'સુવિધા',
        'Temple Guidelines': 'મંદિરના નિયમો',
        'Do\'s': 'કરવા યોગ્ય',
        'Don\'ts': 'ન કરો',
        'Emergency Contacts': 'કટોકટી સંપર્ક',
      };
      return translations[text] ?? text;
    }
    return text; // Return original English text
  }
}
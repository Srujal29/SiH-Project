import 'package:flutter/material.dart';
import 'package:devadarshan/models/temple.dart';
import 'package:devadarshan/services/mock_data_service.dart';

class DarshanBookingScreen extends StatefulWidget {
  const DarshanBookingScreen({super.key});

  @override
  State<DarshanBookingScreen> createState() => _DarshanBookingScreenState();
}

class _DarshanBookingScreenState extends State<DarshanBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<TextEditingController> _familyMemberControllers = [];

  Temple? selectedTemple;
  String? selectedTimeSlot;
  BookingType selectedBookingType = BookingType.normal;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  final List<Temple> temples = MockDataService.getTemples();
  final List<String> timeSlots = MockDataService.getTimeSlots();
  bool isBookingConfirmed = false;
  DarshanBooking? confirmedBooking;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    for (final controller in _familyMemberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addFamilyMember() {
    setState(() {
      _familyMemberControllers.add(TextEditingController());
    });
  }

  void _removeFamilyMember(int index) {
    _familyMemberControllers[index].dispose();
    setState(() {
      _familyMemberControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darshan Booking'),
      ),
      body: isBookingConfirmed
          ? _buildBookingConfirmation()
          : _buildBookingForm(),
    );
  }

  Widget _buildBookingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Select Temple'),
            _buildTempleSelection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Select Date'),
            _buildDateSelection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Select Time Slot'),
            _buildTimeSlotSelection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Booking Type'),
            _buildBookingTypeSelection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Personal Details'),
            _buildPersonalDetails(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canProceedWithBooking() ? _confirmBooking : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Book Darshan Slot',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name (Primary)',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Contact Phone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter phone number' : null,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _familyMemberControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _familyMemberControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Member ${index + 2} Name',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value?.isEmpty == true ? 'Enter member name' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeFamilyMember(index),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Family Member'),
            onPressed: _addFamilyMember,
          ),
        ),
      ],
    );
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      final List<String> allPilgrimNames = [
        _nameController.text,
        ..._familyMemberControllers.map((controller) => controller.text)
      ];
      final booking = DarshanBooking(
        id: 'B${DateTime.now().millisecondsSinceEpoch}',
        templeId: selectedTemple!.id,
        templeName: selectedTemple!.name,
        bookingDate: selectedDate,
        timeSlot: selectedTimeSlot!,
        pilgrimNames: allPilgrimNames,
        pilgrimPhone: _phoneController.text,
        bookingType: selectedBookingType,
        status: BookingStatus.confirmed,
        queuePosition: selectedBookingType == BookingType.vip ? 5 : 25,
      );
      setState(() {
        confirmedBooking = booking;
        isBookingConfirmed = true;
      });
    }
  }

  Widget _buildBookingConfirmation() {
    if (confirmedBooking == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          ),
          const SizedBox(height: 24),
          Text(
            'Booking Confirmed!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildBookingDetail('Booking ID', confirmedBooking!.id),
                  _buildBookingDetail('Temple', confirmedBooking!.templeName),
                  _buildBookingDetail('Pilgrims', confirmedBooking!.pilgrimNames.join(', ')),
                  _buildBookingDetail(
                      'Date',
                      '${confirmedBooking!.bookingDate.day}/${confirmedBooking!.bookingDate.month}/${confirmedBooking!.bookingDate.year}'),
                  _buildBookingDetail('Time Slot', confirmedBooking!.timeSlot),
                  _buildBookingDetail('Booking Type', confirmedBooking!.bookingType.displayText),
                  _buildBookingDetail('Queue Position', '${confirmedBooking!.queuePosition}'),
                  const Divider(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                        children: [
                          Text('QR Code', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Icon(Icons.qr_code_2_rounded, size: 100),
                          const SizedBox(height: 8),
                          Text(confirmedBooking!.qrCode, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                        ],
                    ),
                  ),
                ],
              ),
            ),
          ),
           const SizedBox(height: 24),
           ElevatedButton(
             onPressed: () {
                setState(() {
                  isBookingConfirmed = false;
                  selectedTemple = null;
                  selectedTimeSlot = null;
                  _nameController.clear();
                  _phoneController.clear();
                  for (final controller in _familyMemberControllers) {
                    controller.dispose();
                  }
                  _familyMemberControllers.clear();
                });
             },
             child: const Text('Book Another Darshan'),
           ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
  
  // ## NEW IMPLEMENTATION - NO RADIO WIDGET ##
  Widget _buildTempleSelection() {
    return Column(
      children: temples.map((temple) {
        final isSelected = selectedTemple == temple;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: () => setState(() => selectedTemple = temple),
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(temple.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(temple.location),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getCrowdColor(temple.crowdPercentage).withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${temple.crowdStatus} Crowd',
                        style: TextStyle(
                          color: _getCrowdColor(temple.crowdPercentage),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text('${temple.currentCrowd}/${temple.maxCapacity}'),
                  ],
                ),
              ],
            ),
            trailing: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                temple.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  child: Icon(Icons.temple_hindu,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary),
        title: Text(
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
        subtitle: const Text('Tap to change date'),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 30)),
          );
          if (picked != null) setState(() => selectedDate = picked);
        },
      ),
    );
  }

  Widget _buildTimeSlotSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.map((slot) => ChoiceChip(
            label: Text(slot),
            selected: selectedTimeSlot == slot,
            onSelected: (selected) =>
                setState(() => selectedTimeSlot = selected ? slot : null),
            selectedColor: Theme.of(context).colorScheme.primary.withAlpha(76),
            backgroundColor: Theme.of(context).colorScheme.surface,
          )).toList(),
    );
  }

  // ## NEW IMPLEMENTATION - NO RADIO WIDGET ##
  Widget _buildBookingTypeSelection() {
    return Column(
      children: BookingType.values.map((type) {
        final isSelected = selectedBookingType == type;
        return ListTile(
          onTap: () => setState(() => selectedBookingType = type),
          leading: Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(type.displayText),
        );
      }).toList(),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end,)),
        ],
      ),
    );
  }

  bool _canProceedWithBooking() {
    return selectedTemple != null &&
        selectedTimeSlot != null &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  Color _getCrowdColor(double percentage) {
    if (percentage < 0.3) return Colors.green;
    if (percentage < 0.7) return Colors.orange;
    return Colors.red;
  }
}
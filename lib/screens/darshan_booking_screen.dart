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
  
  Temple? selectedTemple;
  String? selectedTimeSlot;
  BookingType selectedBookingType = BookingType.normal;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  
  final List<Temple> temples = MockDataService.getTemples();
  final List<String> timeSlots = MockDataService.getTimeSlots();
  
  bool isBookingConfirmed = false;
  DarshanBooking? confirmedBooking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darshan Booking'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: isBookingConfirmed ? _buildBookingConfirmation() : _buildBookingForm(),
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
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Book Darshan Slot', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
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

  Widget _buildTempleSelection() {
    return Column(
      children: temples.map((temple) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: RadioListTile<Temple>(
          value: temple,
          groupValue: selectedTemple,
          onChanged: (Temple? value) => setState(() => selectedTemple = value),
          title: Text(temple.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(temple.location),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getCrowdColor(temple.crowdPercentage).withValues(alpha: 0.1),
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
          secondary: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              temple.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 50,
                height: 50,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                child: Icon(Icons.temple_hindu, color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      )).toList(),
    );
  }

  Widget _buildDateSelection() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
        title: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
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
        onSelected: (selected) => setState(() => selectedTimeSlot = selected ? slot : null),
        selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        backgroundColor: Theme.of(context).colorScheme.surface,
      )).toList(),
    );
  }

  Widget _buildBookingTypeSelection() {
    return Column(
      children: [
        RadioListTile<BookingType>(
          value: BookingType.normal,
          groupValue: selectedBookingType,
          onChanged: (value) => setState(() => selectedBookingType = value!),
          title: const Text('Normal Darshan'),
          subtitle: const Text('Standard queue • Free'),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        RadioListTile<BookingType>(
          value: BookingType.vip,
          groupValue: selectedBookingType,
          onChanged: (value) => setState(() => selectedBookingType = value!),
          title: const Text('VIP Darshan'),
          subtitle: const Text('Priority queue • For elderly/disabled'),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        RadioListTile<BookingType>(
          value: BookingType.noBooking,
          groupValue: selectedBookingType,
          onChanged: (value) => setState(() => selectedBookingType = value!),
          title: const Text('Walk-in (No Booking)'),
          subtitle: const Text('Direct entry • Subject to capacity'),
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
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
      ],
    );
  }

  Widget _buildBookingConfirmation() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
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
                  _buildBookingDetail('Date', '${confirmedBooking!.bookingDate.day}/${confirmedBooking!.bookingDate.month}/${confirmedBooking!.bookingDate.year}'),
                  _buildBookingDetail('Time Slot', confirmedBooking!.timeSlot),
                  _buildBookingDetail('Booking Type', _getBookingTypeText(confirmedBooking!.bookingType)),
                  _buildBookingDetail('Queue Position', '${confirmedBooking!.queuePosition}'),
                  const Divider(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'QR Code',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Center(
                            child: Icon(Icons.qr_code, size: 80, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          confirmedBooking!.qrCode,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      final booking = DarshanBooking(
        id: 'B${DateTime.now().millisecondsSinceEpoch}',
        templeId: selectedTemple!.id,
        templeName: selectedTemple!.name,
        bookingDate: selectedDate,
        timeSlot: selectedTimeSlot!,
        pilgrimName: _nameController.text,
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

  Color _getCrowdColor(double percentage) {
    if (percentage < 0.3) return Colors.green;
    if (percentage < 0.7) return Colors.orange;
    return Colors.red;
  }

  String _getBookingTypeText(BookingType type) {
    switch (type) {
      case BookingType.normal: return 'Normal Darshan';
      case BookingType.vip: return 'VIP Darshan';
      case BookingType.noBooking: return 'Walk-in';
    }
  }
}
class Temple {
  final String id;
  final String name;
  final String location;
  final String description;
  final int currentCrowd;
  final int maxCapacity;
  final List<String> timings;
  final bool isOpen;
  final String imageUrl;

  Temple({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.currentCrowd,
    required this.maxCapacity,
    required this.timings,
    required this.isOpen,
    required this.imageUrl,
  });

  double get crowdPercentage => currentCrowd / maxCapacity;
  
  String get crowdStatus {
    if (crowdPercentage < 0.3) return 'Low';
    if (crowdPercentage < 0.7) return 'Moderate';
    return 'High';
  }
}

class DarshanBooking {
  final String id;
  final String templeId;
  final String templeName;
  final DateTime bookingDate;
  final String timeSlot;
  final List<String> pilgrimNames;
  final String pilgrimPhone;
  final BookingType bookingType;
  final BookingStatus status;
  final int queuePosition;

  DarshanBooking({
    required this.id,
    required this.templeId,
    required this.templeName,
    required this.bookingDate,
    required this.timeSlot,
    required this.pilgrimNames,
    required this.pilgrimPhone,
    required this.bookingType,
    required this.status,
    required this.queuePosition,
  });

  String get qrCode => 'TEMPLE_$templeId-BOOKING_$id-${bookingDate.day}${bookingDate.month}';
}

// ## UPDATED ENUM ##
// This is the new, enhanced enum.
enum BookingType {
  normal('Normal Darshan'),
  vip('VIP Darshan'),
  noBooking('Walk-in (No Booking)');

  final String displayText;
  const BookingType(this.displayText);
}

enum BookingStatus { confirmed, inQueue, completed, cancelled }

class EmergencyAlert {
  final String id;
  final String type;
  final String description;
  final String location;
  final DateTime timestamp;
  final EmergencyStatus status;
  final String? responderId;

  EmergencyAlert({
    required this.id,
    required this.type,
    required this.description,
    required this.location,
    required this.timestamp,
    required this.status,
    this.responderId,
  });
}

enum EmergencyStatus { active, responding, resolved }

class LostFoundItem {
  final String id;
  final String type;
  final String description;
  final String reporterName;
  final String reporterPhone;
  final String location;
  final DateTime timestamp;
  final LostFoundStatus status;
  final String? imageUrl;

  LostFoundItem({
    required this.id,
    required this.type,
    required this.description,
    required this.reporterName,
    required this.reporterPhone,
    required this.location,
    required this.timestamp,
    required this.status,
    this.imageUrl,
  });
}

enum LostFoundStatus { reported, searching, found, closed }
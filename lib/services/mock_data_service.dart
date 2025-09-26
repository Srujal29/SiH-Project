import '../models/temple.dart';

class MockDataService {
  static List<Temple> getTemples() {
    return [
       Temple(
        id: 'somnath',
        name: 'Somnath Temple',
        location: 'Somnath, Gujarat',
        description: 'First among the twelve Jyotirlinga shrines of Shiva',
        currentCrowd: 1200,
        maxCapacity: 2000,
        timings: ['5:00 AM - 9:30 PM'],
        isOpen: true,
        // ## CHANGED: Use local asset path ##
        imageUrl: 'assets/images/Somanath_Temple.jpg',
      ),
      Temple(
        id: 'dwarka',
        name: 'Dwarkadhish Temple',
        location: 'Dwarka, Gujarat',
        description: 'Sacred abode of Lord Krishna',
        currentCrowd: 800,
        maxCapacity: 1500,
        timings: ['6:00 AM - 12:30 PM', '5:00 PM - 9:30 PM'],
        isOpen: true,
        // ## CHANGED: Use local asset path ##
        imageUrl: 'assets/images/dwarka.webp',
      ),
      Temple(
        id: 'ambaji',
        name: 'Ambaji Temple',
        location: 'Ambaji, Gujarat',
        description: 'Goddess Amba temple, one of the 51 Shakti Peethas',
        currentCrowd: 600,
        maxCapacity: 1200,
        timings: ['5:00 AM - 10:00 PM'],
        isOpen: true,
        // ## CHANGED: Use local asset path ##
        imageUrl: 'assets/images/ambaji.jpg',
      ),
      Temple(
        id: 'pavagadh',
        name: 'Kalika Mata Temple',
        location: 'Pavagadh, Gujarat',
        description: 'Historic temple on Pavagadh Hill',
        currentCrowd: 400,
        maxCapacity: 800,
        timings: ['6:00 AM - 8:00 PM'],
        isOpen: true,
        // ## CHANGED: Use local asset path ##
        imageUrl: 'assets/images/pavagadh.jpg',
      ),
    ];
  }

  static List<String> getTimeSlots() {
    return [
      '5:00 AM - 6:00 AM',
      '6:00 AM - 7:00 AM',
      '7:00 AM - 8:00 AM',
      '8:00 AM - 9:00 AM',
      '9:00 AM - 10:00 AM',
      '10:00 AM - 11:00 AM',
      '11:00 AM - 12:00 PM',
      '5:00 PM - 6:00 PM',
      '6:00 PM - 7:00 PM',
      '7:00 PM - 8:00 PM',
      '8:00 PM - 9:00 PM',
    ];
  }

  static List<DarshanBooking> getSampleBookings() {
    return [
      DarshanBooking(
        id: 'B001',
        templeId: 'somnath',
        templeName: 'Somnath Temple',
        bookingDate: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '7:00 AM - 8:00 AM',
        // FIXED HERE: Changed pilgrimName to pilgrimNames and wrapped the name in a list
        pilgrimNames: ['Rajesh Patel'],
        pilgrimPhone: '+91 9876543210',
        bookingType: BookingType.normal,
        status: BookingStatus.confirmed,
        queuePosition: 15,
      ),
      DarshanBooking(
        id: 'B002',
        templeId: 'dwarka',
        templeName: 'Dwarkadhish Temple',
        bookingDate: DateTime.now(),
        timeSlot: '6:00 PM - 7:00 PM',
        // FIXED HERE: Changed pilgrimName to pilgrimNames and wrapped the name in a list
        pilgrimNames: ['Priya Sharma', 'Rohan Sharma'],
        pilgrimPhone: '+91 8765432109',
        bookingType: BookingType.vip,
        status: BookingStatus.inQueue,
        queuePosition: 3,
      ),
    ];
  }

  static List<EmergencyAlert> getEmergencyAlerts() {
    return [
      EmergencyAlert(
        id: 'E001',
        type: 'Medical Emergency',
        description: 'Elderly person collapsed near main entrance',
        location: 'Somnath Temple - Main Gate',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        status: EmergencyStatus.responding,
        responderId: 'MEDIC_01',
      ),
      EmergencyAlert(
        id: 'E002',
        type: 'Crowd Control',
        description: 'Heavy crowd buildup at darshan queue',
        location: 'Dwarka Temple - Queue Area',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        status: EmergencyStatus.resolved,
      ),
    ];
  }

  static List<LostFoundItem> getLostFoundItems() {
    return [
      LostFoundItem(
        id: 'LF001',
        type: 'Person',
        description: 'Missing child, age 8, wearing red dress',
        reporterName: 'Sunita Mehta',
        reporterPhone: '+91 7654321098',
        location: 'Ambaji Temple - Prayer Hall',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: LostFoundStatus.searching,
      ),
      LostFoundItem(
        id: 'LF002',
        type: 'Item',
        description: 'Gold bracelet with Lord Ganesha pendant',
        reporterName: 'Mahesh Kumar',
        reporterPhone: '+91 6543210987',
        location: 'Pavagadh Temple - Courtyard',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        status: LostFoundStatus.found,
      ),
    ];
  }

  static Map<String, dynamic> getCrowdAnalytics() {
    return {
      'todayVisitors': 15420,
      'weeklyAverage': 12800,
      'peakHours': ['7:00-9:00 AM', '6:00-8:00 PM'],
      'prediction': {
        'tomorrow': 18500,
        'confidence': 85,
        'factors': ['Festival Day', 'Good Weather', 'Weekend']
      },
      'heatMapData': [
        {'area': 'Main Temple', 'density': 85},
        {'area': 'Queue Area', 'density': 70},
        {'area': 'Parking', 'density': 45},
        {'area': 'Prasad Counter', 'density': 60},
        {'area': 'Rest Area', 'density': 25},
      ],
    };
  }

  static List<Map<String, dynamic>> getParkingData() {
    return [
      {
        'name': 'Main Parking',
        'totalSpots': 200,
        'occupiedSpots': 160,
        'distance': '100m from temple',
        'type': 'Free'
      },
      {
        'name': 'VIP Parking',
        'totalSpots': 50,
        'occupiedSpots': 35,
        'distance': '50m from temple',
        'type': 'Paid'
      },
      {
        'name': 'Overflow Parking',
        'totalSpots': 300,
        'occupiedSpots': 120,
        'distance': '300m from temple',
        'type': 'Free'
      },
    ];
  }
}
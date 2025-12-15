// Firestore Data Seeder Script
// Run this once to populate Firestore with test data
//
// Usage: After the app starts, call FirestoreSeeder.seedAll() from a button or debug menu
// Or uncomment the call in main.dart temporarily

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Seed all test data
  static Future<void> seedAll() async {
    print('🌱 Starting Firestore seeding...');
    await seedAnnouncements();
    await seedServices();
    await seedBuildings();
    await seedRooms();
    await seedScheduleClasses();
    print('✅ Firestore seeding complete!');
  }

  /// Seed announcements collection
  static Future<void> seedAnnouncements() async {
    final collection = _firestore.collection('announcements');
    
    // Check if already seeded
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('📢 Announcements already exist, skipping...');
      return;
    }

    final announcements = [
      {
        'title': 'Welcome to Smart Campus!',
        'content': 'Welcome to the new semester! Check out all the new features in the Smart Campus Companion app. Navigate the campus, find rooms, check your schedule, and stay updated with the latest announcements.',
        'category': 'general',
        'publishedAt': Timestamp.now(),
        'isPinned': true,
        'imageUrl': '',
      },
      {
        'title': 'Library Extended Hours',
        'content': 'The main library will be open 24/7 during finals week starting December 16th. Study rooms can be booked via the app. Free coffee available from 10 PM to 6 AM!',
        'category': 'academic',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 2))),
        'isPinned': false,
        'imageUrl': '',
      },
      {
        'title': 'Campus Event: Tech Fair 2024',
        'content': 'Join us this Friday for the annual Tech Fair! Meet with industry leaders, showcase your projects, and network with potential employers. Free pizza and drinks!',
        'category': 'event',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 5))),
        'isPinned': false,
        'imageUrl': '',
      },
      {
        'title': '⚠️ Building B Closed for Maintenance',
        'content': 'Building B will be closed on Saturday and Sunday for emergency HVAC repairs. All classes have been moved to Building C. Check the app for updated room assignments.',
        'category': 'urgent',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 1))),
        'isPinned': true,
        'imageUrl': '',
      },
      {
        'title': 'New Shuttle Bus Route',
        'content': 'A new express shuttle route connecting the main campus to the downtown student housing is now available. Runs every 15 minutes from 7 AM to 11 PM.',
        'category': 'general',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'isPinned': false,
        'imageUrl': '',
      },
      {
        'title': 'Career Fair Registration Open',
        'content': 'Register now for the Spring Career Fair on January 15th. Over 50 companies will be recruiting. Bring your resume and dress professionally!',
        'category': 'event',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8))),
        'isPinned': false,
        'imageUrl': '',
      },
      {
        'title': 'Campus WiFi Upgrade',
        'content': 'The campus WiFi network has been upgraded to support faster speeds. Please reconnect using your student credentials.',
        'category': 'general',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
        'isPinned': false,
        'imageUrl': '',
      },
      {
        'title': 'Student Club Applications',
        'content': 'Applications for new student clubs are now open! Submit your proposal by January 20th to start a new organization.',
        'category': 'academic',
        'publishedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 12))),
        'isPinned': false,
        'imageUrl': '',
      },
    ];

    for (final announcement in announcements) {
      await collection.add(announcement);
    }

    print('📢 Added ${announcements.length} announcements');
  }

  /// Seed services collection
  static Future<void> seedServices() async {
    final collection = _firestore.collection('services');
    
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('🏢 Services already exist, skipping...');
      return;
    }

    final services = [
      {
        'name': 'Library',
        'description': 'Access books, journals, digital resources, and quiet study spaces',
        'category': 'Academic',
        'iconName': 'local_library',
        'hours': '08:00 - 22:00',
        'location': 'Main Building, Ground Floor',
        'phone': '+1-555-0101',
        'email': 'library@campus.edu',
        'isActive': true,
      },
      {
        'name': 'IT Support',
        'description': 'Technical assistance, software support, and computer labs',
        'category': 'Technical',
        'iconName': 'computer',
        'hours': '09:00 - 17:00',
        'location': 'Building B, Room 101',
        'phone': '+1-555-0102',
        'email': 'it.support@campus.edu',
        'isActive': true,
      },
      {
        'name': 'Cafeteria',
        'description': 'Fresh meals, snacks, and beverages for students and staff',
        'category': 'Dining',
        'iconName': 'restaurant',
        'hours': '07:00 - 20:00',
        'location': 'Student Center, Level 1',
        'isActive': true,
      },
      {
        'name': 'Health Center',
        'description': 'Medical services, counseling, and wellness programs',
        'category': 'Health',
        'iconName': 'local_hospital',
        'hours': '08:00 - 18:00',
        'location': 'Building D, Room 105',
        'phone': '+1-555-0103',
        'email': 'health@campus.edu',
        'isActive': true,
      },
      {
        'name': 'Sports Complex',
        'description': 'Gym, swimming pool, tennis courts, and fitness classes',
        'category': 'Recreation',
        'iconName': 'fitness_center',
        'hours': '06:00 - 22:00',
        'location': 'Sports Building',
        'phone': '+1-555-0104',
        'isActive': true,
      },
      {
        'name': 'Student Affairs',
        'description': 'Administrative services, ID cards, and student support',
        'category': 'Administrative',
        'iconName': 'assignment_ind',
        'hours': '08:30 - 16:30',
        'location': 'Admin Building, Room 201',
        'phone': '+1-555-0105',
        'email': 'affairs@campus.edu',
        'isActive': true,
      },
      {
        'name': 'Printing Services',
        'description': 'Printing, copying, scanning, and binding services',
        'category': 'Technical',
        'iconName': 'print',
        'hours': '08:00 - 18:00',
        'location': 'Library, Ground Floor',
        'isActive': true,
      },
      {
        'name': 'Career Center',
        'description': 'Career counseling, resume reviews, and job placements',
        'category': 'Career',
        'iconName': 'work',
        'hours': '09:00 - 17:00',
        'location': 'Building C, Room 201',
        'email': 'careers@campus.edu',
        'isActive': true,
      },
      {
        'name': 'Bookstore',
        'description': 'Textbooks, supplies, merchandise, and campus gear',
        'category': 'Shopping',
        'iconName': 'store',
        'hours': '08:00 - 19:00',
        'location': 'Student Center, Level 2',
        'phone': '+1-555-0106',
        'isActive': true,
      },
      {
        'name': 'Financial Aid',
        'description': 'Scholarships, loans, grants, and payment plans',
        'category': 'Administrative',
        'iconName': 'attach_money',
        'hours': '08:30 - 16:30',
        'location': 'Admin Building, Room 105',
        'phone': '+1-555-0107',
        'email': 'finaid@campus.edu',
        'isActive': true,
      },
      {
        'name': 'Counseling Services',
        'description': 'Mental health support, stress management, and therapy',
        'category': 'Health',
        'iconName': 'psychology',
        'hours': '09:00 - 17:00',
        'location': 'Building D, Room 210',
        'phone': '+1-555-0108',
        'email': 'counseling@campus.edu',
        'isActive': true,
      },
      {
        'name': 'International Office',
        'description': 'Visa support, international student services, and exchange programs',
        'category': 'Administrative',
        'iconName': 'language',
        'hours': '09:00 - 16:00',
        'location': 'Admin Building, Room 301',
        'email': 'international@campus.edu',
        'isActive': true,
      },
    ];

    for (final service in services) {
      await collection.add(service);
    }

    print('🏢 Added ${services.length} services');
  }

  /// Seed buildings collection
  static Future<void> seedBuildings() async {
    final collection = _firestore.collection('buildings');
    
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('🏗️ Buildings already exist, skipping...');
      return;
    }

    final buildings = [
      {'name': 'Building A', 'code': 'A', 'floors': 4, 'description': 'Main academic building - Sciences & Mathematics'},
      {'name': 'Building B', 'code': 'B', 'floors': 3, 'description': 'Engineering, IT & Computer Science'},
      {'name': 'Building C', 'code': 'C', 'floors': 4, 'description': 'Business, Economics & Management'},
      {'name': 'Building D', 'code': 'D', 'floors': 2, 'description': 'Health Sciences & Student Services'},
      {'name': 'Library', 'code': 'LIB', 'floors': 3, 'description': 'Central library & study spaces'},
      {'name': 'Student Center', 'code': 'SC', 'floors': 2, 'description': 'Cafeteria, bookstore & student activities'},
      {'name': 'Sports Complex', 'code': 'SP', 'floors': 1, 'description': 'Gym, pool & sports facilities'},
      {'name': 'Admin Building', 'code': 'ADM', 'floors': 3, 'description': 'Administrative offices & registration'},
    ];

    for (final building in buildings) {
      await collection.add(building);
    }

    print('🏗️ Added ${buildings.length} buildings');
  }

  /// Seed rooms collection
  static Future<void> seedRooms() async {
    final collection = _firestore.collection('rooms');
    
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('🚪 Rooms already exist, skipping...');
      return;
    }

    // Get building IDs
    final buildingsSnapshot = await _firestore.collection('buildings').get();
    final buildingMap = <String, String>{};
    for (final doc in buildingsSnapshot.docs) {
      buildingMap[doc.data()['code'] as String] = doc.id;
    }

    final rooms = [
      // Building A - Sciences
      {'name': 'A101', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 1, 'capacity': 60, 'isAvailable': true, 'type': 'Lecture Hall', 'amenities': ['Projector', 'Whiteboard', 'Audio System']},
      {'name': 'A102', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 1, 'capacity': 40, 'isAvailable': false, 'currentEvent': 'Introduction to Physics', 'type': 'Classroom'},
      {'name': 'A103', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 1, 'capacity': 30, 'isAvailable': true, 'type': 'Lab', 'amenities': ['Lab Equipment', 'Safety Gear']},
      {'name': 'A201', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 2, 'capacity': 45, 'isAvailable': true, 'type': 'Classroom'},
      {'name': 'A202', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 2, 'capacity': 35, 'isAvailable': false, 'currentEvent': 'Calculus II', 'type': 'Classroom'},
      {'name': 'A301', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 3, 'capacity': 50, 'isAvailable': true, 'type': 'Lecture Hall'},
      {'name': 'A302', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 3, 'capacity': 25, 'isAvailable': true, 'type': 'Seminar Room'},
      {'name': 'A401', 'buildingId': buildingMap['A'], 'buildingName': 'Building A', 'floor': 4, 'capacity': 20, 'isAvailable': false, 'currentEvent': 'Research Meeting', 'type': 'Conference Room'},
      
      // Building B - Engineering/IT
      {'name': 'B101', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 1, 'capacity': 30, 'isAvailable': true, 'type': 'Computer Lab', 'amenities': ['30 Workstations', 'Dual Monitors']},
      {'name': 'B102', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 1, 'capacity': 40, 'isAvailable': false, 'currentEvent': 'Mobile App Development', 'type': 'Lab'},
      {'name': 'B103', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 1, 'capacity': 25, 'isAvailable': true, 'type': 'Hardware Lab', 'amenities': ['Soldering Stations', 'Oscilloscopes']},
      {'name': 'B201', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 2, 'capacity': 60, 'isAvailable': true, 'type': 'Lecture Hall'},
      {'name': 'B202', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 2, 'capacity': 35, 'isAvailable': false, 'currentEvent': 'Data Structures', 'type': 'Classroom'},
      {'name': 'B301', 'buildingId': buildingMap['B'], 'buildingName': 'Building B', 'floor': 3, 'capacity': 20, 'isAvailable': true, 'type': 'Project Room', 'amenities': ['3D Printer', 'Large Display']},
      
      // Building C - Business
      {'name': 'C101', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 1, 'capacity': 80, 'isAvailable': false, 'currentEvent': 'Economics 101', 'type': 'Auditorium'},
      {'name': 'C102', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 1, 'capacity': 40, 'isAvailable': true, 'type': 'Classroom'},
      {'name': 'C201', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 2, 'capacity': 50, 'isAvailable': true, 'type': 'Seminar Room'},
      {'name': 'C202', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 2, 'capacity': 30, 'isAvailable': false, 'currentEvent': 'Marketing Strategies', 'type': 'Classroom'},
      {'name': 'C301', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 3, 'capacity': 100, 'isAvailable': false, 'currentEvent': 'Guest Lecture: Entrepreneurship', 'type': 'Auditorium'},
      {'name': 'C401', 'buildingId': buildingMap['C'], 'buildingName': 'Building C', 'floor': 4, 'capacity': 15, 'isAvailable': true, 'type': 'Meeting Room'},
      
      // Library
      {'name': 'LIB-101', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 1, 'capacity': 20, 'isAvailable': true, 'type': 'Study Room', 'amenities': ['Quiet Zone', 'Power Outlets']},
      {'name': 'LIB-102', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 1, 'capacity': 8, 'isAvailable': false, 'currentEvent': 'Study Group', 'type': 'Group Study'},
      {'name': 'LIB-103', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 1, 'capacity': 6, 'isAvailable': true, 'type': 'Private Room'},
      {'name': 'LIB-201', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 2, 'capacity': 30, 'isAvailable': true, 'type': 'Computer Area', 'amenities': ['15 PCs', 'Printers']},
      {'name': 'LIB-202', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 2, 'capacity': 50, 'isAvailable': true, 'type': 'Reading Room'},
      {'name': 'LIB-301', 'buildingId': buildingMap['LIB'], 'buildingName': 'Library', 'floor': 3, 'capacity': 12, 'isAvailable': false, 'currentEvent': 'Research Workshop', 'type': 'Media Room'},
      
      // Student Center
      {'name': 'SC-101', 'buildingId': buildingMap['SC'], 'buildingName': 'Student Center', 'floor': 1, 'capacity': 100, 'isAvailable': true, 'type': 'Event Hall'},
      {'name': 'SC-102', 'buildingId': buildingMap['SC'], 'buildingName': 'Student Center', 'floor': 1, 'capacity': 30, 'isAvailable': false, 'currentEvent': 'Club Meeting', 'type': 'Activity Room'},
      {'name': 'SC-201', 'buildingId': buildingMap['SC'], 'buildingName': 'Student Center', 'floor': 2, 'capacity': 50, 'isAvailable': true, 'type': 'Multi-Purpose Room'},
    ];

    for (final room in rooms) {
      await collection.add(room);
    }

    print('🚪 Added ${rooms.length} rooms');
  }

  /// Seed schedule classes collection
  static Future<void> seedScheduleClasses() async {
    final collection = _firestore.collection('classes');
    
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      print('📅 Classes already exist, skipping...');
      return;
    }

    // Create schedule for CS101 (Computer Science 1st Year)
    final cs101Classes = [
      // Monday
      {'classId': 'CS101', 'name': 'Introduction to Computer Science', 'instructor': 'Dr. Smith', 'room': 'A101', 'building': 'Building A', 'dayOfWeek': 1, 'startTime': '09:00', 'endTime': '10:30', 'color': '#4CAF50'},
      {'classId': 'CS101', 'name': 'Calculus I', 'instructor': 'Prof. Anderson', 'room': 'A202', 'building': 'Building A', 'dayOfWeek': 1, 'startTime': '11:00', 'endTime': '12:30', 'color': '#2196F3'},
      {'classId': 'CS101', 'name': 'Data Structures', 'instructor': 'Dr. Williams', 'room': 'B201', 'building': 'Building B', 'dayOfWeek': 1, 'startTime': '14:00', 'endTime': '15:30', 'color': '#FF9800'},
      
      // Tuesday
      {'classId': 'CS101', 'name': 'Mobile App Development', 'instructor': 'Prof. Johnson', 'room': 'B102', 'building': 'Building B', 'dayOfWeek': 2, 'startTime': '09:00', 'endTime': '10:30', 'color': '#9C27B0'},
      {'classId': 'CS101', 'name': 'Physics for Engineers', 'instructor': 'Dr. Chen', 'room': 'A102', 'building': 'Building A', 'dayOfWeek': 2, 'startTime': '11:00', 'endTime': '12:30', 'color': '#E91E63'},
      {'classId': 'CS101', 'name': 'Database Systems', 'instructor': 'Prof. Brown', 'room': 'B201', 'building': 'Building B', 'dayOfWeek': 2, 'startTime': '14:00', 'endTime': '15:30', 'color': '#00BCD4'},
      
      // Wednesday
      {'classId': 'CS101', 'name': 'Introduction to Computer Science', 'instructor': 'Dr. Smith', 'room': 'A101', 'building': 'Building A', 'dayOfWeek': 3, 'startTime': '09:00', 'endTime': '10:30', 'color': '#4CAF50'},
      {'classId': 'CS101', 'name': 'Software Engineering', 'instructor': 'Dr. Davis', 'room': 'C201', 'building': 'Building C', 'dayOfWeek': 3, 'startTime': '11:00', 'endTime': '12:30', 'color': '#FF5722'},
      {'classId': 'CS101', 'name': 'Computer Lab', 'instructor': 'TA Team', 'room': 'B101', 'building': 'Building B', 'dayOfWeek': 3, 'startTime': '14:00', 'endTime': '16:00', 'color': '#607D8B'},
      
      // Thursday
      {'classId': 'CS101', 'name': 'Mobile App Development', 'instructor': 'Prof. Johnson', 'room': 'B102', 'building': 'Building B', 'dayOfWeek': 4, 'startTime': '09:00', 'endTime': '10:30', 'color': '#9C27B0'},
      {'classId': 'CS101', 'name': 'Calculus I', 'instructor': 'Prof. Anderson', 'room': 'A202', 'building': 'Building A', 'dayOfWeek': 4, 'startTime': '11:00', 'endTime': '12:30', 'color': '#2196F3'},
      {'classId': 'CS101', 'name': 'Data Structures', 'instructor': 'Dr. Williams', 'room': 'B201', 'building': 'Building B', 'dayOfWeek': 4, 'startTime': '14:00', 'endTime': '15:30', 'color': '#FF9800'},
      
      // Friday
      {'classId': 'CS101', 'name': 'Physics for Engineers', 'instructor': 'Dr. Chen', 'room': 'A103', 'building': 'Building A', 'dayOfWeek': 5, 'startTime': '09:00', 'endTime': '11:00', 'color': '#E91E63'},
      {'classId': 'CS101', 'name': 'Software Engineering', 'instructor': 'Dr. Davis', 'room': 'C201', 'building': 'Building C', 'dayOfWeek': 5, 'startTime': '14:00', 'endTime': '15:30', 'color': '#FF5722'},
    ];

    // Create schedule for BA201 (Business Administration 2nd Year)
    final ba201Classes = [
      // Monday
      {'classId': 'BA201', 'name': 'Marketing Fundamentals', 'instructor': 'Prof. Miller', 'room': 'C101', 'building': 'Building C', 'dayOfWeek': 1, 'startTime': '10:00', 'endTime': '11:30', 'color': '#3F51B5'},
      {'classId': 'BA201', 'name': 'Financial Accounting', 'instructor': 'Dr. White', 'room': 'C201', 'building': 'Building C', 'dayOfWeek': 1, 'startTime': '13:00', 'endTime': '14:30', 'color': '#009688'},
      
      // Tuesday
      {'classId': 'BA201', 'name': 'Business Statistics', 'instructor': 'Prof. Garcia', 'room': 'C102', 'building': 'Building C', 'dayOfWeek': 2, 'startTime': '09:00', 'endTime': '10:30', 'color': '#795548'},
      {'classId': 'BA201', 'name': 'Organizational Behavior', 'instructor': 'Dr. Taylor', 'room': 'C201', 'building': 'Building C', 'dayOfWeek': 2, 'startTime': '14:00', 'endTime': '15:30', 'color': '#673AB7'},
      
      // Wednesday
      {'classId': 'BA201', 'name': 'Marketing Fundamentals', 'instructor': 'Prof. Miller', 'room': 'C101', 'building': 'Building C', 'dayOfWeek': 3, 'startTime': '10:00', 'endTime': '11:30', 'color': '#3F51B5'},
      {'classId': 'BA201', 'name': 'Business Law', 'instructor': 'Prof. Martinez', 'room': 'C301', 'building': 'Building C', 'dayOfWeek': 3, 'startTime': '14:00', 'endTime': '15:30', 'color': '#F44336'},
      
      // Thursday
      {'classId': 'BA201', 'name': 'Financial Accounting', 'instructor': 'Dr. White', 'room': 'C201', 'building': 'Building C', 'dayOfWeek': 4, 'startTime': '11:00', 'endTime': '12:30', 'color': '#009688'},
      {'classId': 'BA201', 'name': 'Business Statistics', 'instructor': 'Prof. Garcia', 'room': 'C102', 'building': 'Building C', 'dayOfWeek': 4, 'startTime': '14:00', 'endTime': '15:30', 'color': '#795548'},
      
      // Friday
      {'classId': 'BA201', 'name': 'Entrepreneurship Workshop', 'instructor': 'Guest Speakers', 'room': 'C301', 'building': 'Building C', 'dayOfWeek': 5, 'startTime': '10:00', 'endTime': '12:00', 'color': '#CDDC39'},
    ];

    // Create schedule for ENG301 (Engineering 3rd Year)
    final eng301Classes = [
      // Monday
      {'classId': 'ENG301', 'name': 'Control Systems', 'instructor': 'Dr. Lee', 'room': 'B201', 'building': 'Building B', 'dayOfWeek': 1, 'startTime': '08:00', 'endTime': '09:30', 'color': '#FF5722'},
      {'classId': 'ENG301', 'name': 'Digital Signal Processing', 'instructor': 'Prof. Kim', 'room': 'B103', 'building': 'Building B', 'dayOfWeek': 1, 'startTime': '11:00', 'endTime': '12:30', 'color': '#00BCD4'},
      
      // Tuesday
      {'classId': 'ENG301', 'name': 'Machine Learning', 'instructor': 'Dr. Patel', 'room': 'B101', 'building': 'Building B', 'dayOfWeek': 2, 'startTime': '09:00', 'endTime': '10:30', 'color': '#9C27B0'},
      {'classId': 'ENG301', 'name': 'Engineering Lab', 'instructor': 'Lab Staff', 'room': 'B103', 'building': 'Building B', 'dayOfWeek': 2, 'startTime': '14:00', 'endTime': '17:00', 'color': '#607D8B'},
      
      // Wednesday
      {'classId': 'ENG301', 'name': 'Control Systems', 'instructor': 'Dr. Lee', 'room': 'B201', 'building': 'Building B', 'dayOfWeek': 3, 'startTime': '08:00', 'endTime': '09:30', 'color': '#FF5722'},
      {'classId': 'ENG301', 'name': 'Project Management', 'instructor': 'Prof. Wilson', 'room': 'B301', 'building': 'Building B', 'dayOfWeek': 3, 'startTime': '11:00', 'endTime': '12:30', 'color': '#4CAF50'},
      
      // Thursday
      {'classId': 'ENG301', 'name': 'Machine Learning', 'instructor': 'Dr. Patel', 'room': 'B101', 'building': 'Building B', 'dayOfWeek': 4, 'startTime': '09:00', 'endTime': '10:30', 'color': '#9C27B0'},
      {'classId': 'ENG301', 'name': 'Digital Signal Processing', 'instructor': 'Prof. Kim', 'room': 'B103', 'building': 'Building B', 'dayOfWeek': 4, 'startTime': '13:00', 'endTime': '14:30', 'color': '#00BCD4'},
      
      // Friday
      {'classId': 'ENG301', 'name': 'Capstone Project', 'instructor': 'Faculty Advisors', 'room': 'B301', 'building': 'Building B', 'dayOfWeek': 5, 'startTime': '09:00', 'endTime': '12:00', 'color': '#E91E63'},
    ];

    final allClasses = [...cs101Classes, ...ba201Classes, ...eng301Classes];

    for (final classData in allClasses) {
      await collection.add(classData);
    }

    print('📅 Added ${allClasses.length} schedule classes for 3 programs (CS101, BA201, ENG301)');
  }

  /// Clear all seeded data (use carefully!)
  static Future<void> clearAll() async {
    print('🗑️ Clearing Firestore data...');
    
    final collections = ['announcements', 'services', 'buildings', 'rooms', 'classes'];
    
    for (final collectionName in collections) {
      final snapshot = await _firestore.collection(collectionName).get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('  Cleared $collectionName');
    }
    
    print('✅ Cleared all data');
  }
}

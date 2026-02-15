
import 'package:flutter/material.dart';

class CarBookingApp extends StatelessWidget {
  const CarBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Booking UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial', // افتراض خط بسيط
      ),
      home: const CarBookingScreen(),
    );
  }
}

class CarBookingScreen extends StatefulWidget {
  const CarBookingScreen({super.key});

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

enum ReservationType { go, goAndBack, perHour }
enum TransportationService { yes, no }
enum PaymentMethod { bank, net }

class _CarBookingScreenState extends State<CarBookingScreen> {
  final ReservationType _reservationType = ReservationType.go;
  final TransportationService _transportationService = TransportationService.yes;
  final PaymentMethod _paymentMethod = PaymentMethod.bank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Placeholder for Logo/VIP Express Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'الخدمة المميزة',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'VIP EXPRESS',
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Placeholder for Logo Image
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF003366),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_car, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF003366)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header Text
            const Text(
              'In City',
              style: TextStyle(
                color: Color(0xFFD90000),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            const Text(
              'Request to book a car with driver',
              style: TextStyle(
                color: Color(0xFFD90000),
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            // Reservation Date
            _buildReservationField(
              label: 'Reservation Date',
              icon: Icons.calendar_today,
              hintText: 'mm / dd / yyyy',
            ),
            const SizedBox(height: 10),

            // Reservation Time
            _buildReservationField(
              label: 'Reservation Time',
              icon: Icons.access_time,
              hintText: '.. : .. : ..',
            ),
            const SizedBox(height: 20),

            // Car Category Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: const [
                  Icon(Icons.arrow_drop_down, color: Colors.grey),
                  Expanded(
                    child: Text(
                      'Car Category',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.directions_car, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Reservation Type
            const Text(
              'Reservation Type',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildRadioTile(
                  title: 'بالساعة',
                  value: ReservationType.perHour,
                  groupValue: _reservationType,
                  // onChanged: (ReservationType? value) {
                  //   // setState(() {
                  //   //   _reservationType = value;
                  //   // });
                  // },
                ),
                _buildRadioTile(
                  title: 'ذهاب وعودة',
                  value: ReservationType.goAndBack,
                  groupValue: _reservationType,
                  // onChanged: (ReservationType? value) {
                  //   setState(() {
                  //     _reservationType = value;
                  //   });
                  // },
                ),
                _buildRadioTile(
                  title: 'ذهاب',
                  value: ReservationType.go,
                  groupValue: _reservationType,
                  // onChanged: (ReservationType? value) {
                  //   setState(() {
                  //     _reservationType = value;
                  //   });
                  // },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Count of Peoples
            _buildTextFieldWithLabel(
              label: 'Count Of Peoples',
              icon: null,
              hintText: '',
            ),
            const SizedBox(height: 20),

            // Client Name
            _buildTextFieldWithIcon(
              icon: Icons.person,
              hintText: 'Client Name',
            ),
            const SizedBox(height: 10),

            // Client Mobile
            _buildTextFieldWithIcon(
              icon: Icons.phone,
              hintText: 'Client Mobile',
            ),
            const SizedBox(height: 20),

            // Your Requirements
            _buildTextFieldWithLabel(
              label: 'Your Requirements',
              icon: null,
              hintText: '',
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Transportation Service
            const Text(
              'Transportation Service',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildRadioTile(
                  title: 'لا',
                  value: TransportationService.no,
                  groupValue: _transportationService,
                  // onChanged: (TransportationService? value) {
                  //   setState(() {
                  //     _transportationService = value;
                  //   });
                  // },
                ),
                _buildRadioTile(
                  title: 'نعم',
                  value: TransportationService.yes,
                  groupValue: _transportationService,
                  // onChanged: (TransportationService? value) {
                  //   setState(() {
                  //     _transportationService = value;
                  //   });
                  // },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Method
            const Text(
              'Payment Method',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildRadioTile(
                  title: 'شبكة',
                  value: PaymentMethod.net,
                  groupValue: _paymentMethod,
                  // onChanged: (PaymentMethod? value) {
                  //   setState(() {
                  //     _paymentMethod = value;
                  //   });
                  // },
                ),
                _buildRadioTile(
                  title: 'بنك',
                  value: PaymentMethod.bank,
                  groupValue: _paymentMethod,
                  // onChanged: (PaymentMethod? value) {
                  //   setState(() {
                  //     _paymentMethod = value;
                  //   });
                  // },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD90000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.person, size: 30, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications, size: 30, color: Colors.grey),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF003366),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.directions_car, size: 30, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.home, size: 30, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationField({
    required String label,
    required IconData icon,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
              Expanded(
                child: Text(
                  hintText,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioTile({
    required String title,
    required dynamic value,
    required dynamic groupValue,
  //  required ValueChanged<dynamic> onChanged,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              color: value == groupValue ? const Color(0xFF003366) : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Radio(
            value: value,
            groupValue: groupValue,
            // onChanged: onChanged,
            activeColor: const Color(0xFF003366),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required IconData icon,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Icon(icon, color: const Color(0xFF003366)),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required IconData? icon,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            textAlign: TextAlign.right,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
